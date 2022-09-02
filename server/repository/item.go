package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
	"mahesabu/graph/model"
)

// CreateItem Items can have the same brand but different price and batch
func CreateItem(DB *gorm.DB, input model.ItemInput, CreatorID int) (*model.Item, error) {
	var Prices []*model.Price

	for _, k := range input.Prices {
		price := model.Price{
			Amount:     k.Amount,
			CreatorID:  CreatorID,
			CategoryID: k.CategoryID,
		}

		Prices = append(Prices, &price)
	}

	item := model.Item{
		AlertQuantity: input.AlertQuantity,
		Quantity:      input.Quantity,
		Batch:         input.Batch,
		Description:   input.Description,
		BuyingPrice:   input.BuyingPrice,
		ExpiresAt:     input.ExpiresAt,
		ProductID:     input.ProductID,
		BrandID:       input.BrandID,
		UnitID:        input.UnitID,
		CreatorID:     &CreatorID,
		Prices:        Prices,
	}

	err := DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(&item).Error; err != nil {
			return err
		}

		//If there are sub categories attached
		_, er := CreateProductCategories(tx, item.ID, model.CategoryTypeSubcategory, input.Categories, CreatorID)

		if er != nil {
			return er
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return &item, nil
}

func EditItem(DB *gorm.DB, ID int, input model.ItemInput, CreatorID int) (*model.Item, error) {
	update := model.Item{
		ID:            ID,
		AlertQuantity: input.AlertQuantity,
		Quantity:      input.Quantity,
		Batch:         input.Batch,
		Description:   input.Description,
		BuyingPrice:   input.BuyingPrice,
		ExpiresAt:     input.ExpiresAt,
		ProductID:     input.ProductID,
		BrandID:       input.BrandID,
		UnitID:        input.UnitID,
		CreatorID:     &CreatorID,
	}

	err := DB.Transaction(func(tx *gorm.DB) error {
		if err := DB.Debug().Model(&model.Item{}).Where(&model.Item{ID: ID}).Updates(&update).Error; err != nil {
			return err
		}

		for _, p := range input.Prices {
			_, err := EditPrice(tx, ID, *p, CreatorID)
			if err != nil {
				return err
			}
		}

		_, err := DeleteProductCategories(tx, ID, model.CategoryTypeSubcategory)
		if err != nil {
			return err
		}

		_, err = CreateProductCategories(tx, ID, model.CategoryTypeSubcategory, input.Categories, CreatorID)

		if err != nil {
			return err
		}
		return nil
	})

	if err != nil {
		return nil, err
	}

	return &update, nil
}

func FindItems(DB *gorm.DB, args model.ItemsArgs, StoreID int) ([]*model.Item, error) {
	var items []*model.Item
	var result *gorm.DB

	b := DB.Table("items").Where("items.quantity > 0") //.Preload("Prices")

	if args.By == model.ItemsByStore {
		result = b.Joins("inner join products on products.id = items.product_id AND products.store_id = ?", StoreID).Find(&items)
	} else if args.By == model.ItemsByCategory {
		result = b.Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.id = ?", args.Value).Find(&items)
	} else if args.By == model.ItemsByProduct {
		result = b.Where(&model.Item{ProductID: args.Value}).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	if result.Error != nil {
		return nil, result.Error
	}

	return items, nil
}

func FindItem(db *gorm.DB, ID int) (*model.Item, error) {
	var item *model.Item
	result := db.Where(&model.Item{ID: ID}).First(&item)
	return item, result.Error
}

func SumItemsCost(db *gorm.DB, StoreID int) ([]*model.ItemsStats, error) {
	var profit []*model.ItemsStats

	a := db.Table("items")
	b := a.Joins("inner join products on items.product_id = products.id AND products.store_id = ?", StoreID)
	d := b.Joins("inner join prices on prices.item_id = items.id")
	e := d.Group("prices.category_id").Where("items.quantity > 0")
	f := e.Select(`
coalesce(sum((prices.amount - items.buying_price) * items.quantity),0) AS expected_profit, 
coalesce(sum(items.buying_price * items.quantity),0) AS total_cost,
coalesce(sum(prices.amount * items.quantity),0) AS total_return,
prices.category_id as category_id
`)

	if err := f.Scan(&profit).Error; err != nil {
		return nil, err
	}

	return profit, nil
}

type FindItemNameAndQuantityResult struct {
	Name     string
	Quantity int
}

func CheckAvailableQuantity(db *gorm.DB, input *model.OrderItemInput) error {
	var available *FindItemNameAndQuantityResult

	//Checking item's quantity if is enough for fulfilling order...
	err := db.Model(&model.Item{}).Joins("inner join products on items.product_id = products.id AND items.id = ? ", input.ItemID).Select("products.name as name, quantity").First(&available).Error

	if err != nil {
		return err
	}

	if available.Quantity < input.Quantity {
		return errors.New(fmt.Sprintf("%s's available quantity is %d which is not enough for %d required", available.Name, available.Quantity, input.Quantity))
	}

	return nil
}

func ConvertItem(DB *gorm.DB, input model.ConvertStockInput) ([]*model.Item, error) {
	var Items []*model.Item

	err := DB.Debug().Transaction(func(tx *gorm.DB) error {
		from, err1 := FindItem(tx, input.From)
		if err1 != nil {
			return err1
		}

		to, err2 := FindItem(tx, input.To)
		if err2 != nil {
			return err1
		}

		if input.Quantity > from.Quantity {
			return errors.New("the required quantity is greater than available quantity")
		}

		if from.ProductID != to.ProductID {
			return errors.New("you can't convert stocks of different products")
		}

		if err := tx.Model(&from).Clauses(clause.Returning{}).UpdateColumn("quantity", gorm.Expr("quantity - ?", input.Quantity)).Error; err != nil {
			return err
		}

		if err := tx.Model(&to).Clauses(clause.Returning{}).UpdateColumn("quantity", gorm.Expr("quantity + ?", input.Quantity*input.EachEqualsTo)).Error; err != nil {
			return err
		}

		Items = append(Items, from)
		Items = append(Items, to)

		return nil
	})

	if err != nil {
		return nil, err
	}

	return Items, nil
}
