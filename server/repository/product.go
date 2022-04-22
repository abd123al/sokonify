package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func FindProducts(DB *gorm.DB, by model.ProductsBy, value int) ([]*model.Product, error) {
	var items []*model.Product
	var result *gorm.DB

	if by == model.ProductsByStore {
		result = DB.Table("products").Joins("inner join categories on categories.id = products.category_id AND categories.store_id = ?", value).Find(&items)
	} else if by == model.ProductsByCategory {
		result = DB.Table("products").Joins("inner join categories on categories.id = products.category_id AND categories.id = ?", value).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	return items, result.Error
}
