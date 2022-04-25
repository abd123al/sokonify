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
