package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateBrand(db *gorm.DB, input model.BrandInput) (*model.Brand, error) {
	brand := model.Brand{
		Name:         input.Name,
		Manufacturer: input.Manufacturer,
		ProductID:    input.ProductID,
	}
	result := db.Create(&brand)
	return &brand, result.Error
}

func FindBrands(db *gorm.DB, ProductID int) ([]*model.Brand, error) {
	var brands []*model.Brand
	result := db.Where(&model.Brand{ProductID: ProductID}).Find(&brands)
	return brands, result.Error
}

func FindBrand(db *gorm.DB, ID int) (*model.Brand, error) {
	var brand *model.Brand
	result := db.Where(&model.Brand{ID: ID}).First(&brand)
	return brand, result.Error
}
