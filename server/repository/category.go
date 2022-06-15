package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateCategory(db *gorm.DB, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.Category, error) {
	category := model.Category{
		Name:        input.Name,
		Description: input.Description,
		StoreID:     &args.StoreID,
		CreatorID:   &args.UserID,
	}
	result := db.Create(&category)
	return &category, result.Error
}

func EditCategory(DB *gorm.DB, ID int, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.Category, error) {
	var category *model.Category

	err := DB.Transaction(func(tx *gorm.DB) error {
		category = &model.Category{
			ID:          ID,
			Name:        input.Name,
			Description: input.Description,
			CreatorID:   &args.UserID, //We just make this as creator
		}

		if err := tx.Model(&category).Where(&model.Category{ID: ID, StoreID: &args.StoreID}).Updates(&category).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return category, nil
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
