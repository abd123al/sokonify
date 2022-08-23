package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateBrand(db *gorm.DB, input model.BrandInput, CreatorID int) (*model.Brand, error) {
	brand := model.Brand{
		Name:         input.Name,
		Manufacturer: input.Manufacturer,
		ProductID:    input.ProductID,
		CreatorID:    &CreatorID,
	}
	result := db.Create(&brand)
	return &brand, result.Error
}

func EditBrand(db *gorm.DB, ID int, input model.BrandInput, CreatorID int) (*model.Brand, error) {
	brand := model.Brand{
		Name:         input.Name,
		Manufacturer: input.Manufacturer,
		ProductID:    input.ProductID,
		CreatorID:    &CreatorID,
	}

	if err := db.Model(&brand).Where(&model.Brand{ID: ID}).Updates(&brand).Error; err != nil {
		return nil, err
	}

	return &brand, nil
}

func FindBrands(db *gorm.DB, args model.BrandsArgs, StoreId int) ([]*model.Brand, error) {
	var result *gorm.DB

	var brands []*model.Brand
	if args.ProductID != nil {
		result = db.Where(&model.Brand{ProductID: *args.ProductID}).Find(&brands)
	} else {
		result = db.Table("brands").Joins("inner join products on products.id = brands.product_id AND products.store_id =?", StoreId).Find(&brands)
	}
	return brands, result.Error
}

func FindBrand(db *gorm.DB, ID int) (*model.Brand, error) {
	var brand *model.Brand
	result := db.Where(&model.Brand{ID: ID}).First(&brand)
	return brand, result.Error
}
