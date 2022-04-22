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

func CreateCustomer(DB *gorm.DB, StoreId int) *model.Customer {
	customer := model.Customer{
		Name:    "John Doe",
		Type:    model.CustomerTypeCustomer,
		StoreID: StoreId,
	}

	DB.Create(&customer)

	return &customer
}

func CreateStore(DB *gorm.DB, OwnerID int) *model.Store {
	store := model.Store{
		Name:    "shop",
		OwnerID: OwnerID,
	}

	DB.Create(&store)

	return &store
}

type CreateStaffArgs struct {
	UserID  int
	StoreID int
}

func CreateStaff(DB *gorm.DB, Args CreateStaffArgs) *model.Staff {
	staff := model.Staff{
		StoreID: Args.StoreID,
		UserID:  Args.UserID,
	}
	DB.Create(&staff)

	return &staff
}

func CreateCategory(DB *gorm.DB, StoreID int) *model.Category {
	category := model.Category{
		Name:    "Category",
		StoreID: StoreID,
	}

	DB.Create(&category)

	return &category
}

func CreateProduct(DB *gorm.DB, CategoryID int) *model.Product {
	product := model.Product{
		Name: "Product",
		Brands: []*model.Brand{
			{Name: "Shells"},
			{Name: "Brand"},
		},
	}

	DB.Create(&product)

	//Also saving category
	categoryProduct := model.CategoryProduct{
		CategoryID: CategoryID,
		ProductID:  product.ID,
	}

	DB.Create(&categoryProduct)

	return &product
}

type CreateItemArgs struct {
	BrandID   *int
	ProductID int
}

func CreateItem(DB *gorm.DB, args CreateItemArgs) *model.Item {
	store := model.Item{
		SellingPrice: "5000.00",
		BuyingPrice:  "2000.00",
		//Batch:        "6363663",
		ExpiresAt: time.Now(),
		ProductID: args.ProductID,
		BrandID:   args.BrandID,
	}

	DB.Create(&store)

	return &store
}

type CreateOrderArgs struct {
	IssuerID   int
	UserId     int
	CustomerID int
	ItemID     int
}

func CreateOrder(DB *gorm.DB, args CreateOrderArgs) *model.Order {
	store := model.Order{
		IssuerID:   args.IssuerID,
		StaffID:    args.UserId,
		CustomerID: &args.CustomerID,
		Type:       model.OrderTypeSale,
		Items: []*model.OrderItem{
			{Quantity: 2, Price: "5000.33", ItemID: args.ItemID}, //10,000.66
			{Quantity: 4, Price: "4000.22", ItemID: args.ItemID}, //16,000.88
		},
	}

	DB.Create(&store)

	return &store
}
