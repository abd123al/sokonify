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

	err := DB.Debug().Transaction(func(tx *gorm.DB) error {
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

		_, er := CreateProductCategories(tx, product.ID, model.CategoryTypeCategory, input.Categories, args.UserID)

		if er != nil {
			return er
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return product, nil
}

func EditProduct(DB *gorm.DB, ID int, input model.ProductInput, args helpers.UserAndStoreArgs) (*model.Product, error) {
	var product *model.Product

	err := DB.Transaction(func(tx *gorm.DB) error {
		product = &model.Product{
			ID:          ID,
			Name:        input.Name,
			Description: input.Description,
		}

		if err := tx.Model(&product).Where(&model.Product{ID: ID, StoreID: &args.StoreID}).Updates(&product).Error; err != nil {
			return err
		}

		_, err := DeleteProductCategories(tx, ID, model.CategoryTypeCategory)
		if err != nil {
			return err
		}

		_, err = CreateProductCategories(tx, ID, model.CategoryTypeCategory, input.Categories, args.UserID)

		if err != nil {
			return err
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

func FindProduct(db *gorm.DB, ID int, StoreID int) (*model.Product, error) {
	var product *model.Product
	result := db.Where(&model.Product{ID: ID, StoreID: &StoreID}).First(&product)
	return product, result.Error
}
