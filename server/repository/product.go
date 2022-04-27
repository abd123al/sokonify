package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateProduct(DB *gorm.DB, input model.ProductInput) (*model.Product, error) {
	//todo should this run on transaction?
	var brands []*model.Brand
	var productCategories []*model.ProductCategory

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
		StoreID: &input.StoreID,
	}

	result := DB.Create(&product)

	//making sure ids are unique
	categories := helpers.RemoveDuplicatedInt(input.Categories)

	for _, k := range categories {
		// First checking if there is no previous relationship.
		var cat *model.ProductCategory

		//First() causes panic, so Find works here better
		DB.Where(&model.ProductCategory{ProductID: product.ID, CategoryID: k}).Limit(1).Find(&cat)

		if cat != nil {
			ProductCategory := model.ProductCategory{
				ProductID:  product.ID,
				CategoryID: k,
			}

			productCategories = append(productCategories, &ProductCategory)
		}
	}

	if len(productCategories) > 0 {
		DB.Create(&productCategories)
	}

	return &product, result.Error
}

func FindProducts(DB *gorm.DB, args model.ProductsArgs) ([]*model.Product, error) {
	var items []*model.Product
	var result *gorm.DB

	if args.By != nil {
		if *args.By == model.ProductsByStore {
			result = DB.Table("products").Where(&model.Product{StoreID: args.Value}).Find(&items)
		} else if *args.By == model.ProductsByCategory {
			result = DB.Table("products").Joins("inner join product_categories on product_categories.product_id = products.id AND product_categories.category_id = ?", args.Value).Find(&items)
		} else {
			panic(fmt.Errorf("not implemented"))
		}
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	return items, result.Error
}

func FindProduct(db *gorm.DB, ID int) (*model.Product, error) {
	var product *model.Product
	result := db.Where(&model.Product{ID: ID}).First(&product)
	return product, result.Error
}
