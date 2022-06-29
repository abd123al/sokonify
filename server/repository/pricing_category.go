package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreatePriceCategory(db *gorm.DB, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.PriceCategory, error) {
	category := model.PriceCategory{
		Name:        input.Name,
		Description: input.Description,
		CreatorID:   &args.UserID,
		StoreID:     args.StoreID,
	}

	result := db.Create(&category)
	return &category, result.Error
}

func EditPriceCategory(DB *gorm.DB, ID int, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.PriceCategory, error) {
	var category *model.PriceCategory

	category = &model.PriceCategory{
		ID:          ID,
		Name:        input.Name,
		Description: input.Description,
		CreatorID:   &args.UserID,
		StoreID:     args.StoreID,
	}

	if err := DB.Model(&model.PriceCategory{}).Where(&model.PriceCategory{ID: ID, StoreID: args.StoreID}).Updates(&category).Error; err != nil {
		return nil, err
	}

	return category, nil
}

func FindPriceCategories(db *gorm.DB, storeID int) ([]*model.PriceCategory, error) {
	var categories []*model.PriceCategory
	result := db.Where(&model.PriceCategory{StoreID: storeID}).Find(&categories)
	return categories, result.Error
}

func FindPriceCategory(db *gorm.DB, ID int) (*model.PriceCategory, error) {
	var category *model.PriceCategory
	result := db.Where(&model.PriceCategory{ID: ID}).First(&category)
	return category, result.Error
}
