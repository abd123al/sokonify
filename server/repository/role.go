package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateRole(db *gorm.DB, input model.RoleInput, args helpers.UserAndStoreArgs) (*model.Role, error) {
	category := model.Role{
		Name:        input.Name,
		Description: input.Description,
		StoreID:     args.StoreID,
		CreatorID:   args.UserID,
	}
	result := db.Create(&category)
	return &category, result.Error
}

func EditRole(DB *gorm.DB, ID int, input model.RoleInput, args helpers.UserAndStoreArgs) (*model.Role, error) {
	var category *model.Role

	category = &model.Role{
		ID:          ID,
		Name:        input.Name,
		Description: input.Description,
		CreatorID:   args.UserID,
	}

	if err := DB.Model(&category).Where(&model.Role{ID: ID, StoreID: args.StoreID}).Updates(&category).Error; err != nil {
		return nil, err
	}

	return category, nil
}

func FindRoles(db *gorm.DB, storeID int) ([]*model.Role, error) {
	var categories []*model.Role
	result := db.Where(&model.Role{StoreID: storeID}).Find(&categories)
	return categories, result.Error
}

func FindRole(db *gorm.DB, ID int) (*model.Role, error) {
	var category *model.Role
	result := db.Where(&model.Role{ID: ID}).First(&category)
	return category, result.Error
}
