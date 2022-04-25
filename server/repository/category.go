package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateCategory(db *gorm.DB, input model.CategoryInput) (*model.Category, error) {
	category := model.Category{
		Name:    input.Name,
		StoreID: input.StoreID,
	}
	result := db.Create(&category)
	return &category, result.Error
}

func Categories(db *gorm.DB, storeID int) ([]*model.Category, error) {
	var categories []*model.Category
	result := db.Where(&model.Category{StoreID: storeID}).Find(&categories)
	return categories, result.Error
}
