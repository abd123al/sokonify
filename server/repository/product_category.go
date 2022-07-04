package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateProductCategories(db *gorm.DB, Id int, Type model.CategoryType, Categories []int, CreatorID int) ([]*model.ProductCategory, error) {
	var cats []*model.ProductCategory
	var ProductID, ItemID *int

	//making sure ids are unique
	categories := helpers.RemoveDuplicatedInt(Categories)

	if Type == model.CategoryTypeCategory {
		ProductID = &Id
	} else {
		ItemID = &Id
	}

	for _, k := range categories {
		// First checking if there is no previous relationship.
		var cat *model.ProductCategory

		//First() causes panic, so Find works here better
		db.Where(&model.ProductCategory{ProductID: ProductID, ItemID: ItemID, CategoryID: k}).Limit(1).Find(&cat)

		if cat != nil {
			ProductCategory := model.ProductCategory{
				ItemID:     ItemID,
				ProductID:  ProductID,
				CategoryID: k,
				CreatorID:  &CreatorID,
			}

			cats = append(cats, &ProductCategory)
		}
	}

	if len(cats) > 0 {
		result := db.Model(&model.ProductCategory{}).Create(&cats)
		return cats, result.Error
	}

	return nil, nil
}

// DeleteProductCategories todo not delete categories just update
func DeleteProductCategories(DB *gorm.DB, ID int, Type model.CategoryType) ([]*model.ProductCategory, error) {
	var categories []*model.ProductCategory
	var ProductID, ItemID *int

	if Type == model.CategoryTypeCategory {
		ProductID = &ID
	} else {
		ItemID = &ID
	}

	if err := DB.Where(&model.ProductCategory{ProductID: ProductID, ItemID: ItemID}).Delete(&categories).Error; err != nil {
		return nil, err
	}

	return categories, nil
}
