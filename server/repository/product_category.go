package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateProductCategories(db *gorm.DB, ProductID int, Categories []int) ([]*model.ProductCategory, error) {
	var cats []*model.ProductCategory

	for _, k := range Categories {
		ProductCategory := model.ProductCategory{
			ProductID:  &ProductID,
			CategoryID: k,
		}

		cats = append(cats, &ProductCategory)
	}

	result := db.Model(&model.ProductCategory{}).Create(&cats)
	return cats, result.Error
}

func DeleteProductCategories(DB *gorm.DB, ProductID int) ([]*model.ProductCategory, error) {
	var categories []*model.ProductCategory

	if err := DB.Where(&model.ProductCategory{ProductID: &ProductID}).Delete(&categories).Error; err != nil {
		return nil, err
	}

	return categories, nil
}
