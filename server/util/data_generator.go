package util

import (
	"github.com/bxcodec/faker/v3"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/repository"
)

// CreateUser Upper case means function is exported
func CreateUser(DB *gorm.DB) *model.User {
	password := "password"

	user := model.User{
		Name:     faker.Name(),
		Username: faker.Username(),
		Email:    faker.Email(),
		Password: &password,
	}

	DB.Create(&user)

	return &user
}

func CreateCustomer(DB *gorm.DB, StoreId int) *model.Customer {
	customer, _ := repository.CreateCustomer(DB, model.CustomerInput{
		Name:    faker.Name(),
		Type:    model.CustomerTypeCustomer,
		StoreID: StoreId,
	})

	return customer
}

func CreateStore(DB *gorm.DB, OwnerID *int) *model.Store {
	if OwnerID == nil {
		User := CreateUser(DB)
		OwnerID = &User.ID
	}

	store := model.Store{
		Name:    faker.Name(),
		OwnerID: *OwnerID,
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
		Name:    faker.Name(),
		StoreID: StoreID,
	}

	DB.Create(&category)

	return &category
}

type CreateProductArgs struct {
	CategoryId *int
	StoreID    int
}

func CreateProduct(DB *gorm.DB, Args *CreateProductArgs) *model.Product {
	var StoreID int
	var Categories []int

	if Args == nil {
		StoreID = CreateStore(DB, nil).ID
	} else {
		StoreID = Args.StoreID

		if Args.CategoryId != nil {
			Categories = append(Categories, *Args.CategoryId)
		}
	}

	product, _ := repository.CreateProduct(DB, model.ProductInput{
		StoreID:    StoreID,
		Categories: Categories,
		Name:       faker.Name(),
		Brands: []*model.ProductBrandInput{
			{Name: faker.Word()},
			{Name: faker.Word()},
		},
	})

	return product
}

type CreateItemArgs struct {
	BrandID   *int
	ProductID int
}

func CreateItem(DB *gorm.DB, args *CreateItemArgs) *model.Item {
	var BrandID *int
	var ProductID int

	//Here what is required is ProductID
	if args != nil {
		BrandID = args.BrandID
		ProductID = args.ProductID
	} else {
		//creating the needed product
		ProductID = CreateProduct(DB, nil).ID
	}

	item, _ := repository.CreateItem(DB, model.ItemInput{
		SellingPrice: "5000.00",
		BuyingPrice:  "2000.00",
		ProductID:    ProductID,
		BrandID:      BrandID,
	})

	return item
}

type CreateOrderArgs struct {
	IssuerID   int
	UserId     int
	CustomerID int
	ItemID     int
}

func CreateOrder(DB *gorm.DB, args CreateOrderArgs) *model.Order {
	store, _ := repository.CreateOrder(DB, args.UserId, model.OrderInput{
		IssuerID:   args.IssuerID,
		CustomerID: &args.CustomerID,
		Type:       model.OrderTypeIn,
		Items: []*model.OrderItemInput{
			{Quantity: 2, Price: "5000.33", ItemID: args.ItemID}, //10,000.66
			{Quantity: 4, Price: "4000.22", ItemID: args.ItemID}, //16,000.88
		},
	})

	return store
}
