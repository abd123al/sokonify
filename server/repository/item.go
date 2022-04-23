package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateItem(DB *gorm.DB, input model.ItemInput) (*model.Item, error) {
	item := model.Item{
		Quantity: input.Quantity,
	}
	result := DB.Create(&item)
	return &item, result.Error
}

func FindItems(DB *gorm.DB, by model.ItemsBy, value int) ([]*model.Item, error) {
	var items []*model.Item
	var result *gorm.DB

	if by == model.ItemsByStore {
		result = DB.Table("items").Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.store_id = ?", value).Find(&items)
	} else if by == model.ItemsByCategory {
		result = DB.Table("items").Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.id = ?", value).Find(&items)
	} else if by == model.ItemsByProduct {
		result = DB.Where(&model.Item{ProductID: value}).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return items, result.Error
}
