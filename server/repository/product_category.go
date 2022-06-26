package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateProductCategories(db *gorm.DB, Id int, Type model.CategoryType, Categories []int) ([]*model.ProductCategory, error) {
	var cats []*model.ProductCategory
	var ProductID, ItemID *int

	if Type == model.CategoryTypeCategory {
		ProductID = &Id
	} else {
		ItemID = &Id
	}

	for _, k := range Categories {
		ProductCategory := model.ProductCategory{
			ItemID:     ItemID,
			ProductID:  ProductID,
			CategoryID: k,
		}

		cats = append(cats, &ProductCategory)
	}

	result := db.Model(&model.ProductCategory{}).Create(&cats)
	return cats, result.Error
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
