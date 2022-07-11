package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

// CreatePermission Permissions are role based. So users are assigned roles
func CreatePermission(db *gorm.DB, input model.PermissionInput, args helpers.UserAndStoreArgs) (*model.Permission, error) {
	category := model.Permission{
		Permission: input.Permission,
		PricingID:  input.PricingID,
		CreatorID:  args.UserID,
		RoleID:     input.RoleID,
	}

	result := db.Create(&category)
	return &category, result.Error
}

func DeletePermission(DB *gorm.DB, ID int) (*model.Permission, error) {
	var category *model.Permission

	if err := DB.Model(&category).Where(&model.Permission{ID: ID}).Delete(&category).Error; err != nil {
		return nil, err
	}

	return category, nil
}

func FindPermissions(db *gorm.DB, RoleID int) ([]*model.Permission, error) {
	var categories []*model.Permission
	result := db.Where(&model.Permission{RoleID: RoleID}).Find(&categories)
	return categories, result.Error
}

func FindPermission(db *gorm.DB, ID int) (*model.Permission, error) {
	var category *model.Permission
	result := db.Where(&model.Permission{ID: ID}).First(&category)
	return category, result.Error
}
