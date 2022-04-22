package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateProduct(DB *gorm.DB, input model.ProductInput) (*model.Product, error) {
	//todo should this run on transaction?
	var brands []*model.Brand
	var productCategories []*model.CategoryProduct

	for _, k := range input.Brands {
		brand := model.Brand{
			Manufacturer: k.Manufacturer,
			Name:         k.Name,
		}

		brands = append(brands, &brand)
	}

	product := model.Product{
		Name:    input.Name,
		Brands:  brands,
		StoreID: input.StoreID,
	}

	result := DB.Create(&product)

	//todo make sure id are unique
	for _, k := range input.Categories {
		// First checking if there is no previous relationship.
		var cat *model.CategoryProduct

		result := DB.Where(&model.CategoryProduct{ProductID: product.ID, CategoryID: k}).First(&cat)

		if result.Error != nil {
			categoryProduct := model.CategoryProduct{
				ProductID:  product.ID,
				CategoryID: k,
			}

			productCategories = append(productCategories, &categoryProduct)
		}
	}

	if len(productCategories) > 0 {
		DB.Create(&productCategories)
	}

	return &product, result.Error
}

func FindProducts(DB *gorm.DB, by model.ProductsBy, value int) ([]*model.Product, error) {
	var items []*model.Product
	var result *gorm.DB

	if by == model.ProductsByStore {
		result = DB.Table("products").Where(&model.Product{StoreID: value}).Find(&items)
	} else if by == model.ProductsByCategory {
		result = DB.Table("products").Joins("inner join category_products on category_products.product_id = products.id AND category_products.category_id = ?", value).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	return items, result.Error
}
