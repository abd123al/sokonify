package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateCategory(db *gorm.DB, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.Category, error) {
	category := model.Category{
		Name:      input.Name,
		StoreID:   &args.StoreID,
		CreatorID: &args.UserID,
	}
	result := db.Create(&category)
	return &category, result.Error
}

func FindCategories(db *gorm.DB, storeID int) ([]*model.Category, error) {
	var categories []*model.Category
	result := db.Where(&model.Category{StoreID: &storeID}).Find(&categories)
	return categories, result.Error
}

func FindCategory(db *gorm.DB, ID int) (*model.Category, error) {
	var category *model.Category
	result := db.Where(&model.Category{ID: ID}).First(&category)
	return category, result.Error
}
