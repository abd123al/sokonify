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

func CreateStaff(DB *gorm.DB, Args *CreateStaffArgs) *model.Staff {
	var UserID int
	var StoreID int

	if Args != nil {
		UserID = Args.UserID
		StoreID = Args.StoreID
	} else {
		UserID = CreateUser(DB).ID
		StoreID = CreateStore(DB, nil).ID
	}

	staff, _ := repository.CreateStaff(DB, model.StaffInput{
		StoreID: StoreID,
		UserID:  UserID,
		Role:    model.StaffRoleStaff,
	})

	return staff
}

func CreateCategory(DB *gorm.DB, StoreID int) *model.Category {
	category := model.Category{
		Name:    faker.Name(),
		StoreID: &StoreID,
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

func CreateItem(DB *gorm.DB, args *CreateItemArgs, StoreId *int) *model.Item {
	var BrandID *int
	var ProductID int

	//Here what is required is ProductID
	if args != nil {
		BrandID = args.BrandID
		ProductID = args.ProductID
	} else {
		//creating the needed product
		if StoreId != nil {
			ProductID = CreateProduct(DB, &CreateProductArgs{StoreID: *StoreId}).ID
		} else {
			ProductID = CreateProduct(DB, nil).ID
		}
	}

	item, _ := repository.CreateItem(DB, model.ItemInput{
		Quantity:     10,
		BuyingPrice:  "2000.00", //todo fake all these
		SellingPrice: "5000.00",
		Batch:        nil,
		Description:  nil,
		ExpiresAt:    nil,
		BrandID:      BrandID,
		ProductID:    ProductID,
	})

	return item
}

type CreateOrderArgs struct {
	IssuerID   int
	StaffId    int
	CustomerID int
	Items      []*model.Item
}

func CreateOrder(DB *gorm.DB, args *CreateOrderArgs) *model.Order {
	var IssuerID int
	var StaffId int
	var CustomerID int

	var Items []*model.Item
	var ItemsInput []*model.OrderItemInput

	if args != nil {
		IssuerID = args.IssuerID
		StaffId = args.StaffId
		CustomerID = args.CustomerID
		Items = args.Items
	} else {
		StaffId = CreateUser(DB).ID
		IssuerID = CreateStore(DB, &StaffId).ID
		CustomerID = CreateCustomer(DB, IssuerID).ID

		Items = []*model.Item{
			CreateItem(DB, nil, &IssuerID),
			CreateItem(DB, nil, &IssuerID),
			CreateItem(DB, nil, &IssuerID),
		}
	}

	for i, item := range Items {
		input := model.OrderItemInput{
			Quantity: i + 2, Price: item.SellingPrice, ItemID: item.ID,
		}

		ItemsInput = append(ItemsInput, &input)
	}

	order, _ := repository.CreateOrder(DB, StaffId, model.OrderInput{
		IssuerID:   IssuerID,
		CustomerID: &CustomerID,
		Type:       model.OrderTypeIn,
		Items:      ItemsInput,
	})

	return order
}

func CreateExpense(DB *gorm.DB, StoreID *int) *model.Expense {
	if StoreID == nil {
		StoreID = &CreateStore(DB, nil).ID
	}

	expense, _ := repository.CreateExpense(DB, model.ExpenseInput{
		StoreID: *StoreID,
		Name:    faker.Name(),
		Type:    model.ExpenseTypeOut,
	})

	return expense
}

type CreatePaymentArgs struct {
	StoreID    int
	StaffID    int
	CustomerID *int
}

type CreatePaymentResult struct {
	StoreID    int
	StaffID    int
	CustomerID *int
	Payment    *model.Payment
}

func CreatePayment(DB *gorm.DB, Args *CreatePaymentArgs, Order bool) CreatePaymentResult {
	var StoreID int
	var StaffID int
	var CustomerID *int
	var payment *model.Payment

	if Args == nil {
		StaffID = CreateStaff(DB, nil).UserID //Remember we use userId mostly and not staff's ID
		StoreID = CreateStore(DB, nil).ID
		_ = CreateStaff(DB, &CreateStaffArgs{
			StoreID: StoreID,
			UserID:  StaffID,
		}).ID
		CustomerID = &CreateCustomer(DB, StoreID).ID
	} else {
		StoreID = Args.StoreID
		StaffID = Args.StaffID
		CustomerID = Args.CustomerID
	}

	if Order {
		item := CreateItem(DB, nil, &StoreID)
		order := CreateOrder(DB, &CreateOrderArgs{
			IssuerID:   StoreID,
			StaffId:    StaffID,
			CustomerID: *CustomerID,
			Items:      []*model.Item{item},
		})
		payment, _ = repository.CreateOrderPayment(DB, StaffID, model.OrderPaymentInput{
			OrderID: order.ID,
			Method:  model.PaymentMethodCash,
		})

	} else {
		expense := CreateExpense(DB, &StoreID)

		payment, _ = repository.CreateExpensePayment(DB, StaffID, model.ExpensePaymentInput{
			ExpenseID: expense.ID,
			Method:    model.PaymentMethodCash,
			Amount:    "2000.00",
		})
	}

	result := CreatePaymentResult{
		StoreID:    StoreID,
		StaffID:    StaffID,
		CustomerID: CustomerID,
		Payment:    payment,
	}

	return result
}
