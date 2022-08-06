package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func containsPricing(s []*model.Permission, e int) bool {
	for _, a := range s {
		if a.PricingID == &e {
			return true
		}
	}
	return false
}

func containsPermission(s []*model.Permission, e model.PermissionType) bool {
	for _, a := range s {
		if a.Permission == &e {
			return true
		}
	}
	return false
}

// SetPermissions Permissions are role based. So users are assigned roles
func SetPermissions(db *gorm.DB, input model.PermissionsInput, args helpers.UserAndStoreArgs) ([]*model.Permission, error) {
	var permissions []*model.Permission
	var oldList []*model.Permission

	//todo don't delete
	err := db.Transaction(func(tx *gorm.DB) error {
		del := func(col string) error {
			if err := tx.Table("permissions").Where(fmt.Sprintf("role_id =? AND %s IS NOT NULL", col), input.RoleID).Delete(&oldList).Error; err != nil {
				return err
			}

			return nil
		}

		if len(input.Permissions) > 0 {
			err := del("permission")
			if err != nil {
				return err
			}
		}

		if len(input.PricingIds) > 0 {
			err := del("pricing_id")
			if err != nil {
				return err
			}
		}

		for _, v := range input.Permissions {
			cat := model.Permission{
				Permission: v,
				CreatorID:  args.UserID,
				RoleID:     input.RoleID,
			}

			permissions = append(permissions, &cat)
		}

		for _, v := range input.PricingIds {
			cat := model.Permission{
				PricingID: v,
				CreatorID: args.UserID,
				RoleID:    input.RoleID,
			}

			permissions = append(permissions, &cat)
		}

		if err := tx.Create(&permissions).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return permissions, nil
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
