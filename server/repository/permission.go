package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreatePermission(db *gorm.DB, input model.PermissionInput, args helpers.UserAndStoreArgs) (*model.Permission, error) {
	category := model.Permission{
		Permission: input.Permission,
		CreatorID:  args.UserID,
		RoleID:     input.RoleID,
	}
	result := db.Create(&category)
	return &category, result.Error
}

func EditPermission(DB *gorm.DB, ID int, input model.PermissionInput, args helpers.UserAndStoreArgs) (*model.Permission, error) {
	var category *model.Permission

	err := DB.Transaction(func(tx *gorm.DB) error {
		category = &model.Permission{
			ID:         ID,
			Permission: input.Permission,
			CreatorID:  args.UserID,
			RoleID:     input.RoleID,
		}

		if err := tx.Model(&category).Where(&model.Permission{ID: ID}).Updates(&category).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return category, nil
}

func FindPermissionsByUserId(db *gorm.DB, RoleID int) ([]*model.Permission, error) {
	var categories []*model.Permission
	result := db.Where(&model.Permission{RoleID: RoleID}).Find(&categories)
	return categories, result.Error
}

func FindPermission(db *gorm.DB, ID int) (*model.Permission, error) {
	var category *model.Permission
	result := db.Where(&model.Permission{ID: ID}).First(&category)
	return category, result.Error
}
