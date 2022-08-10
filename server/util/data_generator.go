package util

import (
	"github.com/bxcodec/faker/v3"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
)

// CreateUser Upper case means function is exported
func CreateUser(DB *gorm.DB) *model.User {
	username := faker.Username()

	payload, _ := repository.SignUp(DB, model.SignUpInput{
		Name:     faker.Name(),
		Email:    faker.Email(),
		Password: "password",
		Username: &username,
	})

	return payload.User
}

func CreateCustomer(DB *gorm.DB, StoreId int) *model.Customer {
	customer, _ := repository.CreateCustomer(DB, model.CustomerInput{
		Type: model.CustomerTypeCustomer,
		Name: faker.Name(),
	}, helpers.UserAndStoreArgs{
		UserID:  CreateUser(DB).ID, //todo Problem
		StoreID: StoreId,
	})

	return customer
}

func CreateStore(DB *gorm.DB, UserID *int) *model.Store {
	if UserID == nil {
		User := CreateUser(DB)
		UserID = &User.ID
	}

	store, _ := repository.CreateStore(DB, *UserID, model.StoreInput{
		Name:         faker.Name(),
		BusinessType: model.BusinessTypeBoth,
	}, 100)

	return store
}

type CreateStaffArgs struct {
	UserID  int
	StoreID int
}

type CreateStaffResult struct {
	StoreID int
	Staff   *model.Staff
}

func CreateStaff(DB *gorm.DB, Args *CreateStaffArgs) *CreateStaffResult {
	var UserID int
	var StoreID int

	if Args != nil {
		UserID = Args.UserID
		StoreID = Args.StoreID
	} else {
		UserID = CreateUser(DB).ID
		StoreID = CreateStore(DB, nil).ID
	}

	role := CreateCategory(DB, StoreID, model.CategoryTypeRole)

	staff, _ := repository.CreateStaff(DB, model.StaffInput{
		UserID: UserID,
		RoleID: role.ID,
	}, helpers.UserAndStoreArgs{
		UserID:  UserID,
		StoreID: StoreID,
	})

	return &CreateStaffResult{
		Staff:   staff,
		StoreID: StoreID,
	}
}

func CreateCategory(DB *gorm.DB, StoreID int, categoryType model.CategoryType) *model.Category {
	var PermissionTypes []model.PermissionType
	var PricingIds []int //todo put values here

	if categoryType == model.CategoryTypeRole {
		PermissionTypes = append(PermissionTypes, model.PermissionTypeCreateOrder)
		PermissionTypes = append(PermissionTypes, model.PermissionTypeAddStock)
	}

	category, _ := repository.CreateCategory(DB, model.CategoryInput{
		Name:            faker.Word(),
		Type:            categoryType,
		PermissionTypes: PermissionTypes,
		PricingIds:      PricingIds,
	}, helpers.UserAndStoreArgs{
		UserID:  CreateUser(DB).ID,
		StoreID: StoreID,
	})

	return category
}

type CreateProductArgs struct {
	CategoryId *int
	StoreID    int
}

func CreateProduct(DB *gorm.DB, Args *CreateProductArgs) *model.Product {
	var StoreID int
	var Categories []int

	UserID := CreateUser(DB).ID

	if Args == nil {
		StoreID = CreateStore(DB, nil).ID
	} else {
		StoreID = Args.StoreID

		if Args.CategoryId != nil {
			Categories = append(Categories, *Args.CategoryId)
		}
	}

	product, _ := repository.CreateProduct(DB, model.ProductInput{
		Categories: Categories,
		Name:       faker.Name(),
		Brands: []*model.ProductBrandInput{
			{Name: faker.Word()},
			{Name: faker.Word()},
		},
	}, helpers.UserAndStoreArgs{
		UserID:  UserID,
		StoreID: StoreID,
	})

	return product
}

type CreateItemArgs struct {
	BrandID   *int
	PricingID *int
	StoreID   int
}

func CreateItem(DB *gorm.DB, args CreateItemArgs) *model.Item {
	var BrandID *int
	var Product *model.Product
	var ProductID int
	var CreatorID int
	var PricingID int

	Product = CreateProduct(DB, &CreateProductArgs{StoreID: args.StoreID})
	ProductID = Product.ID
	CreatorID = *Product.CreatorID

	unit := CreateUnit(DB, Product.StoreID, &CreatorID)

	if args.PricingID == nil {
		PricingID = CreateCategory(DB, args.StoreID, model.CategoryTypePricing).ID
	} else {
		PricingID = *args.PricingID
	}

	item, _ := repository.CreateItem(DB, model.ItemInput{
		Quantity:    10,
		BuyingPrice: "2000.00", //todo fake all these
		Batch:       nil,
		Description: nil,
		ExpiresAt:   nil,
		BrandID:     BrandID,
		ProductID:   ProductID,
		UnitID:      unit.ID,
		Prices: []*model.PriceInput{
			{Amount: "500.00", CategoryID: PricingID},
		},
	}, CreatorID)

	return item
}

func CreateUnit(DB *gorm.DB, StoreID *int, UserID *int) *model.Unit {
	unit, _ := repository.CreateUnit(DB, model.UnitInput{
		Name: "Tabs",
	}, repository.CreateUnitsArgs{
		StoreID: StoreID,
		UserID:  UserID,
	})

	return unit
}

type CreateOrderArgs struct {
	IssuerID   int
	StaffId    int
	CustomerID int
	Items      []*model.Item
	PricingID  int
}

type CreateOrderResult struct {
	Order      *model.Order
	IssuerID   int
	StaffId    int
	CustomerID int
	PricingID  int
}

func CreateOrder(DB *gorm.DB, args *CreateOrderArgs) CreateOrderResult {
	var IssuerID int
	var StaffId int
	var CustomerID int
	var PricingID int

	var Items []*model.Item
	var ItemsInput []*model.OrderItemInput

	if args != nil {
		IssuerID = args.IssuerID
		StaffId = args.StaffId
		CustomerID = args.CustomerID
		PricingID = args.PricingID
		Items = args.Items
	} else {
		StaffId = CreateUser(DB).ID
		IssuerID = CreateStore(DB, &StaffId).ID
		CustomerID = CreateCustomer(DB, IssuerID).ID
		PricingID = CreateCategory(DB, IssuerID, model.CategoryTypePricing).ID

		pp := CreateItemArgs{
			PricingID: &PricingID,
			StoreID:   args.IssuerID,
		}
		Items = []*model.Item{
			CreateItem(DB, pp),
			CreateItem(DB, pp),
			CreateItem(DB, pp),
		}
	}

	for i, item := range Items {
		input := model.OrderItemInput{
			Quantity: i + 2, Price: item.Prices[0].Amount, ItemID: item.ID,
		}

		ItemsInput = append(ItemsInput, &input)
	}

	order, _ := repository.CreateOrder(DB, StaffId, model.OrderInput{
		Type:       model.OrderTypeSale,
		CustomerID: &CustomerID,
		PricingID:  PricingID,
		Items:      ItemsInput,
	}, IssuerID)

	result := CreateOrderResult{
		Order:      order,
		IssuerID:   IssuerID,
		StaffId:    StaffId,
		CustomerID: CustomerID,
		PricingID:  PricingID,
	}
	return result
}

func CreateExpense(DB *gorm.DB, StoreID *int) *model.Expense {
	UserID := CreateUser(DB).ID

	if StoreID == nil {
		StoreID = &CreateStore(DB, &UserID).ID
	}

	expense, _ := repository.CreateExpense(DB, model.ExpenseInput{
		Name: faker.Name(),
		Type: model.ExpenseTypeOut,
	}, helpers.UserAndStoreArgs{
		UserID:  UserID,
		StoreID: *StoreID,
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
	PricingID  *int
	CustomerID *int
	Payment    *model.Payment
}

func CreatePayment(DB *gorm.DB, Args *CreatePaymentArgs, Order bool) CreatePaymentResult {
	var StoreID int
	var StaffID int
	var CustomerID *int
	var PricingID *int
	var payment *model.Payment

	if Args == nil {
		StaffID = CreateStaff(DB, nil).Staff.UserID //Remember we use userId mostly and not staff's ID
		StoreID = CreateStore(DB, nil).ID

		_ = CreateStaff(DB, &CreateStaffArgs{
			StoreID: StoreID,
			UserID:  StaffID,
		}).Staff.ID
		CustomerID = &CreateCustomer(DB, StoreID).ID
	} else {
		StoreID = Args.StoreID
		StaffID = Args.StaffID
		CustomerID = Args.CustomerID
	}

	if Order {
		PricingID = &CreateCategory(DB, StoreID, model.CategoryTypePricing).ID

		item := CreateItem(DB, CreateItemArgs{
			StoreID:   StoreID,
			PricingID: PricingID,
		})

		order := CreateOrder(DB, &CreateOrderArgs{
			IssuerID:   StoreID,
			StaffId:    StaffID,
			CustomerID: *CustomerID,
			PricingID:  *PricingID,
			Items:      []*model.Item{item},
		})
		payment, _ = repository.CreateOrderPayment(DB, StaffID, model.OrderPaymentInput{
			OrderID: order.Order.ID,
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
		PricingID:  PricingID,
	}

	return result
}
