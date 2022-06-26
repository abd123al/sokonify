package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

// CreateItem Items can have the same brand but different price and batch
func CreateItem(DB *gorm.DB, input model.ItemInput, CreatorID int) (*model.Item, error) {
	item := model.Item{
		Quantity:     input.Quantity,
		Batch:        input.Batch,
		Description:  input.Description,
		BuyingPrice:  input.BuyingPrice,
		SellingPrice: input.SellingPrice,
		ExpiresAt:    input.ExpiresAt,
		ProductID:    input.ProductID,
		BrandID:      input.BrandID,
		UnitID:       input.UnitID,
		CreatorID:    &CreatorID,
	}

	err := DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(&item).Error; err != nil {
			return err
		}

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
		ID:           ID,
		Quantity:     input.Quantity,
		Batch:        input.Batch,
		Description:  input.Description,
		BuyingPrice:  input.BuyingPrice,
		SellingPrice: input.SellingPrice,
		ExpiresAt:    input.ExpiresAt,
		ProductID:    input.ProductID,
		BrandID:      input.BrandID,
		UnitID:       input.UnitID,
		CreatorID:    &CreatorID,
	}

	if err := DB.Model(&model.Item{}).Where(&model.Item{ID: ID, CreatorID: &CreatorID}).Updates(&update).Error; err != nil {
		return nil, err
	}

	return &update, nil
}

func FindItems(DB *gorm.DB, args model.ItemsArgs, StoreID int) ([]*model.Item, error) {
	var items []*model.Item
	var result *gorm.DB

	query := DB.Table("items").Where("items.quantity > 0")

	if args.By == model.ItemsByStore {
		result = query.Joins("inner join products on products.id = items.product_id AND products.store_id = ?", StoreID).Find(&items)
	} else if args.By == model.ItemsByCategory {
		result = query.Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.id = ?", args.Value).Find(&items)
	} else if args.By == model.ItemsByProduct {
		result = query.Where(&model.Item{ProductID: args.Value}).Find(&items)
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

func SumItemsCost(db *gorm.DB, StoreID int) (*model.ItemsStats, error) {
	var profit *model.ItemsStats

	if err := db.Table("items").Joins("inner join products on items.product_id = products.id AND products.store_id = ?", StoreID).Where("items.quantity > 0").Select("sum((items.selling_price - items.buying_price) * items.quantity) AS expected_profit, sum(items.buying_price * items.quantity) AS total_cost,sum(items.selling_price * items.quantity) AS total_return ").Scan(&profit).Error; err != nil {
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
