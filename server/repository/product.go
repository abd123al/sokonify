package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateProduct(DB *gorm.DB, input model.ProductInput, args helpers.UserAndStoreArgs) (*model.Product, error) {
	var brands []*model.Brand
	var product *model.Product
	var productCategories []*model.ProductCategory

	err := DB.Transaction(func(tx *gorm.DB) error {
		for _, k := range input.Brands {
			brand := model.Brand{
				Manufacturer: k.Manufacturer,
				Name:         k.Name,
			}

			brands = append(brands, &brand)
		}

		product = &model.Product{
			Name:        input.Name,
			Brands:      brands,
			StoreID:     &args.StoreID,
			CreatorID:   &args.UserID,
			Description: input.Description,
		}

		if err := tx.Create(&product).Error; err != nil {
			return err
		}

		//making sure ids are unique
		categories := helpers.RemoveDuplicatedInt(input.Categories)

		for _, k := range categories {
			// First checking if there is no previous relationship.
			var cat *model.ProductCategory

			//First() causes panic, so Find works here better
			tx.Where(&model.ProductCategory{ProductID: product.ID, CategoryID: k}).Limit(1).Find(&cat)

			if cat != nil {
				ProductCategory := model.ProductCategory{
					ProductID:  product.ID,
					CategoryID: k,
				}

				productCategories = append(productCategories, &ProductCategory)
			}
		}

		if len(productCategories) > 0 {
			if err := tx.Create(&productCategories).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return product, nil
}

func FindProducts(DB *gorm.DB, args model.ProductsArgs, StoreID int) ([]*model.Product, error) {
	var items []*model.Product
	var result *gorm.DB

	if args.By != nil {
		if *args.By == model.ProductsByStore {
			result = DB.Table("products").Where(&model.Product{StoreID: &StoreID}).Find(&items)
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
