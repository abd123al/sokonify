package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateCategory(db *gorm.DB, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.Category, error) {
	category := model.Category{
		Name:        input.Name,
		Description: input.Description,
		Type:        input.Type,
		StoreID:     &args.StoreID,
		CreatorID:   &args.UserID,
	}

	err := db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Table("categories").Create(&category).Error; err != nil {
			return err
		}

		var Permissions []*model.Permission

		if input.Type == model.CategoryTypeRole {
			for _, k := range input.PermissionTypes {
				p := model.Permission{
					CreatorID:  args.UserID,
					Permission: &k,
					RoleID:     category.ID,
				}

				Permissions = append(Permissions, &p)
			}

			for _, k := range input.PricingIds {
				p := model.Permission{
					CreatorID: args.UserID,
					PricingID: &k,
					RoleID:    category.ID,
				}

				Permissions = append(Permissions, &p)
			}
		}

		if len(Permissions) > 0 {
			if err := tx.Create(&Permissions).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return &category, nil
}

func EditCategory(DB *gorm.DB, ID int, input model.CategoryInput, args helpers.UserAndStoreArgs) (*model.Category, error) {
	var category *model.Category

	err := DB.Transaction(func(tx *gorm.DB) error {
		category = &model.Category{
			ID:          ID,
			Name:        input.Name,
			Description: input.Description,
			//Type:        input.Type, no need
			CreatorID: &args.UserID, //We just make this as creator
		}

		if err := tx.Model(&category).Where(&model.Category{ID: ID, StoreID: &args.StoreID}).Updates(&category).Error; err != nil {
			return err
		}

		//For cubits to work
		category.Type = input.Type

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

func FindProductCategories(db *gorm.DB, Type model.CategoryType, ProductID int) ([]*model.Category, error) {
	var categories []*model.Category
	var word string

	if Type == model.CategoryTypeCategory {
		word = "product_id"
	} else {
		word = "item_id"
	}

	if err := db.Table("categories").Joins(fmt.Sprintf("inner join product_categories on product_categories.category_id = categories.id AND product_categories.%s = ?", word), ProductID).Find(&categories).Error; err != nil {
		return nil, err
	}

	return categories, nil
}

func FindCategory(db *gorm.DB, ID int) (*model.Category, error) {
	var category *model.Category
	result := db.Where(&model.Category{ID: ID}).First(&category)
	return category, result.Error
}
