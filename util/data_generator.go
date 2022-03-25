package util

import (
	"github.com/bxcodec/faker/v3"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"time"
)

// CreateUser Upper case means function is exported
func CreateUser(DB *gorm.DB) *model.User {
	user := model.User{}

	_ = faker.FakeData(&user)

	DB.Create(&user)

	return &user
}

func CreateStore(DB *gorm.DB, OwnerID int) *model.Store {
	store := model.Store{
		Name:    "shop",
		OwnerID: OwnerID,
	}

	DB.Create(&store)

	return &store
}

func CreateCategory(DB *gorm.DB, StoreID int) *model.Category {
	category := model.Category{
		Name:    "Category",
		StoreID: StoreID,
		Unit:    "tabs",
	}

	DB.Create(&category)

	return &category
}

func CreateProduct(DB *gorm.DB, CategoryID int) *model.Product {
	product := model.Product{
		Name:       "Product",
		CategoryID: CategoryID,
	}

	DB.Create(&product)

	return &product
}

type CreateItemArgs struct {
	BrandID   *int
	ProductID int
}

func CreateItem(DB *gorm.DB, args CreateItemArgs) *model.Item {
	store := model.Item{
		SellingPrice: "777848",
		BuyingPrice:  "2355",
		//Batch:        "6363663",
		ExpiresAt: time.Now(),
		ProductID: args.ProductID,
		BrandID:   args.BrandID,
	}

	DB.Create(&store)

	return &store
}
