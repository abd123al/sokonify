package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateItem(DB *gorm.DB, input model.ItemInput) (*model.Item, error) {
	item := model.Item{
		Quantity:     input.Quantity,
		ProductID:    input.ProductID,
		BuyingPrice:  input.BuyingPrice,
		SellingPrice: input.SellingPrice,
		Batch:        input.Batch,
		Description:  input.Description,
		BrandID:      input.BrandID,
	}

	//to avoid: invalid memory address or nil pointer dereference
	if input.ExpiresAt != nil {
		item.ExpiresAt = *input.ExpiresAt
	}

	result := DB.Create(&item)
	return &item, result.Error
}

func FindItems(DB *gorm.DB, args model.ItemsArgs) ([]*model.Item, error) {
	var items []*model.Item
	var result *gorm.DB

	if args.By == model.ItemsByStore {
		result = DB.Table("items").Joins("inner join products on products.id = items.product_id AND products.store_id = ?", args.Value).Find(&items)
	} else if args.By == model.ItemsByCategory {
		result = DB.Table("items").Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.id = ?", args.Value).Find(&items)
	} else if args.By == model.ItemsByProduct {
		result = DB.Where(&model.Item{ProductID: args.Value}).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return items, result.Error
}

func FindItem(db *gorm.DB, ID int) (*model.Item, error) {
	var item *model.Item
	result := db.Where(&model.Item{ID: ID}).First(&item)
	return item, result.Error
}
