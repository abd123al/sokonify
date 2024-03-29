package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"errors"
	"fmt"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"strconv"
	"strings"

	"github.com/shopspring/decimal"
)

func (r *adminResolver) Password(ctx context.Context, obj *model.Admin) (*string, error) {
	return nil, nil
}

func (r *authPayloadResolver) User(ctx context.Context, obj *model.AuthPayload) (*model.User, error) {
	//In signIn and signUp we have user object, so we just resolve that.
	if obj.User != nil {
		return obj.User, nil
	}

	//You may wonder how can we use jwt while user is just login.
	//Since this is only used in switch store there is no problem
	//Because it requires user to be logged in
	return repository.FindUser(r.DB, helpers.ForContext(ctx).UserID)
}

func (r *brandResolver) Product(ctx context.Context, obj *model.Brand) (*model.Product, error) {
	return repository.FindProduct(r.DB, obj.ProductID, helpers.ForContext(ctx).StoreID)
}

func (r *brandResolver) Creator(ctx context.Context, obj *model.Brand) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *categoryResolver) Creator(ctx context.Context, obj *model.Category) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *categoryResolver) Store(ctx context.Context, obj *model.Category) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *customerResolver) Store(ctx context.Context, obj *model.Customer) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *customerResolver) User(ctx context.Context, obj *model.Customer) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *customerResolver) Creator(ctx context.Context, obj *model.Customer) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *expenseResolver) Store(ctx context.Context, obj *model.Expense) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *expenseResolver) Creator(ctx context.Context, obj *model.Expense) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *itemResolver) Name(ctx context.Context, obj *model.Item) (*string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *itemResolver) BuyingPrice(ctx context.Context, obj *model.Item) (string, error) {
	return obj.BuyingPrice, nil
}

func (r *itemResolver) Creator(ctx context.Context, obj *model.Item) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *itemResolver) Product(ctx context.Context, obj *model.Item) (*model.Product, error) {
	return repository.FindProduct(r.DB, obj.ProductID, helpers.ForContext(ctx).StoreID)
}

func (r *itemResolver) Brand(ctx context.Context, obj *model.Item) (*model.Brand, error) {
	if obj.BrandID != nil {
		return repository.FindBrand(r.DB, *obj.BrandID)
	}

	return nil, nil
}

func (r *itemResolver) Unit(ctx context.Context, obj *model.Item) (*model.Unit, error) {
	return repository.FindUnit(r.DB, obj.UnitID)
}

func (r *itemResolver) Categories(ctx context.Context, obj *model.Item) ([]*model.Category, error) {
	return repository.FindProductCategories(r.DB, model.CategoryTypeSubcategory, obj.ID)
}

func (r *itemResolver) Prices(ctx context.Context, obj *model.Item) ([]*model.Price, error) {
	return repository.FindPrices(r.DB, obj.ID)
}

func (r *mutationResolver) ConvertStock(ctx context.Context, input model.ConvertStockInput) ([]*model.Item, error) {
	return repository.ConvertItem(r.DB, input)
}

func (r *mutationResolver) CreateBrand(ctx context.Context, input model.BrandInput) (*model.Brand, error) {
	return repository.CreateBrand(r.DB, input, helpers.ForContext(ctx).UserID)
}

func (r *mutationResolver) CreateCategory(ctx context.Context, input model.CategoryInput) (*model.Category, error) {
	return repository.CreateCategory(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateCustomer(ctx context.Context, input model.CustomerInput) (*model.Customer, error) {
	return repository.CreateCustomer(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateExpense(ctx context.Context, input model.ExpenseInput) (*model.Expense, error) {
	return repository.CreateExpense(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	return repository.CreateItem(r.DB, input, helpers.ForContext(ctx).UserID)
}

func (r *mutationResolver) CreateOrder(ctx context.Context, input model.OrderInput) (*model.Order, error) {
	return repository.CreateOrder(r.DB, helpers.ForContext(ctx).UserID, input, helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateOrderItem(ctx context.Context, id int, input model.OrderItemInput) (*model.OrderItem, error) {
	//return repository.CreateOrderItems(r.DB, id, input)
	return nil, nil
}

func (r *mutationResolver) CreateOrderPayment(ctx context.Context, input model.OrderPaymentInput) (*model.Payment, error) {
	return repository.CreateOrderPayment(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) CreateExpensePayment(ctx context.Context, input model.ExpensePaymentInput) (*model.Payment, error) {
	return repository.CreateExpensePayment(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) CreateProduct(ctx context.Context, input model.ProductInput) (*model.Product, error) {
	return repository.CreateProduct(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateSales(ctx context.Context, input model.SalesInput) (*model.Payment, error) {
	return repository.CreateSalePayment(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateStaff(ctx context.Context, input model.StaffInput) (*model.Staff, error) {
	return repository.CreateStaff(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) CreateStore(ctx context.Context, input model.StoreInput) (*model.Store, error) {
	return repository.CreateStore(r.DB, helpers.ForContext(ctx).UserID, input, r.NoOfStores)
}

func (r *mutationResolver) CreateUnit(ctx context.Context, input model.UnitInput) (*model.Unit, error) {
	return repository.CreateUnit(r.DB, input, repository.CreateUnitsArgs{
		UserID:  &helpers.ForContext(ctx).UserID,
		StoreID: &helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) ChangePassword(ctx context.Context, input model.ChangePasswordInput) (bool, error) {
	return repository.ChangePassword(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) EditBrand(ctx context.Context, id int, input model.BrandInput) (*model.Brand, error) {
	return repository.EditBrand(r.DB, id, input, helpers.ForContext(ctx).UserID)
}

func (r *mutationResolver) EditCategory(ctx context.Context, id int, input model.CategoryInput) (*model.Category, error) {
	return repository.EditCategory(r.DB, id, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) EditCustomer(ctx context.Context, id int, input model.CustomerInput) (*model.Customer, error) {
	return repository.EditCustomer(r.DB, id, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) EditItem(ctx context.Context, id int, input model.ItemInput) (*model.Item, error) {
	return repository.EditItem(r.DB, id, input, helpers.ForContext(ctx).UserID)
}

func (r *mutationResolver) EditOrder(ctx context.Context, id int, input model.OrderInput) (*model.Order, error) {
	return repository.EditOrder(r.DB, id, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) EditOrderItem(ctx context.Context, id int, input model.OrderItemInput) (*model.OrderItem, error) {
	return repository.EditOrderItem(r.DB, id, input)
}

func (r *mutationResolver) EditProduct(ctx context.Context, id int, input model.ProductInput) (*model.Product, error) {
	return repository.EditProduct(r.DB, id, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) EditProfile(ctx context.Context, input model.ProfileInput) (*model.User, error) {
	return repository.EditProfile(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) EditStaff(ctx context.Context, id int, input model.StaffInput) (*model.Staff, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditStore(ctx context.Context, id int, input model.StoreInput) (*model.Store, error) {
	return repository.EditStore(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: id,
	})
}

func (r *mutationResolver) EditUnit(ctx context.Context, id int, input model.UnitInput) (*model.Unit, error) {
	return repository.EditUnit(r.DB, id, input, repository.CreateUnitsArgs{
		UserID:  &helpers.ForContext(ctx).UserID,
		StoreID: &helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) DeleteItem(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) DeleteOrderItem(ctx context.Context, orderID int, itemID int) (*model.OrderItem, error) {
	return repository.DeleteOrderItem(r.DB, orderID, itemID)
}

func (r *mutationResolver) DeletePermission(ctx context.Context, id int) (*model.Permission, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) Ping(ctx context.Context) (string, error) {
	return "pong", nil
}

func (r *mutationResolver) SetPermissions(ctx context.Context, input model.PermissionsInput) ([]*model.Permission, error) {
	return repository.SetPermissions(r.DB, input, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) SignIn(ctx context.Context, input model.SignInInput) (*model.AuthPayload, error) {
	return repository.SignIn(r.DB, input)
}

func (r *mutationResolver) SignUp(ctx context.Context, input model.SignUpInput) (*model.AuthPayload, error) {
	return repository.SignUp(r.DB, input)
}

func (r *mutationResolver) SwitchStore(ctx context.Context, input model.SwitchStoreInput) (*model.AuthPayload, error) {
	return repository.SwitchStore(r.DB, helpers.UserAndStoreArgs{
		StoreID: input.StoreID,
		UserID:  helpers.ForContext(ctx).UserID,
	})
}

func (r *orderResolver) TotalPrice(ctx context.Context, obj *model.Order) (*string, error) {
	var totalPrice decimal.Decimal

	for _, o := range obj.OrderItems {
		SubTotalPrice, err := decimal.NewFromString(o.SubTotalPrice)
		if err != nil {
			panic(err)
		}

		totalPrice = totalPrice.Add(SubTotalPrice)
	}

	total := totalPrice.String()
	return &total, nil
}

func (r *orderResolver) Pricing(ctx context.Context, obj *model.Order) (*model.Category, error) {
	return repository.FindCategory(r.DB, obj.PricingID)
}

func (r *orderResolver) Customer(ctx context.Context, obj *model.Order) (*model.Customer, error) {
	if obj.CustomerID != nil {
		return repository.FindCustomer(r.DB, *obj.CustomerID)
	}
	return nil, nil
}

func (r *orderResolver) Staff(ctx context.Context, obj *model.Order) (*model.User, error) {
	return repository.FindUser(r.DB, obj.StaffID)
}

func (r *orderResolver) Issuer(ctx context.Context, obj *model.Order) (*model.Store, error) {
	return repository.FindStore(r.DB, obj.IssuerID)
}

func (r *orderResolver) Receiver(ctx context.Context, obj *model.Order) (*model.Store, error) {
	if obj.CustomerID != nil {
		return repository.FindStore(r.DB, *obj.ReceiverID)
	}
	return nil, nil
}

func (r *orderResolver) OrderItems(ctx context.Context, obj *model.Order) ([]*model.OrderItem, error) {
	return repository.FindOrderItems(r.DB, obj.ID)
}

func (r *orderResolver) Payment(ctx context.Context, obj *model.Order) (*model.Payment, error) {
	return repository.FindPaymentByOrderId(r.DB, obj.ID)
}

func (r *orderItemResolver) SubTotalPrice(ctx context.Context, obj *model.OrderItem) (string, error) {
	fromString, err := decimal.NewFromString(obj.Price)
	if err != nil {
		return "", err
	}

	v := fromString.Mul(decimal.NewFromInt(int64(obj.Quantity)))

	return v.String(), nil
}

func (r *orderItemResolver) Item(ctx context.Context, obj *model.OrderItem) (*model.Item, error) {
	return repository.FindItem(r.DB, obj.ItemID)
}

func (r *paymentResolver) Type(ctx context.Context, obj *model.Payment) (model.PaymentType, error) {
	if strings.Contains(obj.Amount, "-") {
		return model.PaymentTypeExpense, nil
	}

	return model.PaymentTypeOrder, nil
}

func (r *paymentResolver) Name(ctx context.Context, obj *model.Payment) (string, error) {
	if obj.ExpenseID != nil {
		return repository.FindName(r.DB, obj.StaffID)
	}

	result, _ := repository.FindOrderCustomerName(r.DB, *obj.OrderID)

	if result != nil {
		return *result, nil
	}

	str := fmt.Sprintf("#%s", strconv.Itoa(*obj.OrderID))

	return str, nil
}

func (r *paymentResolver) Staff(ctx context.Context, obj *model.Payment) (*model.User, error) {
	return repository.FindUser(r.DB, obj.StaffID)
}

func (r *paymentResolver) Order(ctx context.Context, obj *model.Payment) (*model.Order, error) {
	if obj.OrderID != nil {
		return repository.FindOrder(r.DB, *obj.OrderID)
	}
	return nil, nil
}

func (r *paymentResolver) Expense(ctx context.Context, obj *model.Payment) (*model.Expense, error) {
	if obj.ExpenseID != nil {
		return repository.FindExpense(r.DB, *obj.ExpenseID)
	}
	return nil, nil
}

func (r *paymentResolver) OrderItems(ctx context.Context, obj *model.Payment) ([]*model.OrderItem, error) {
	if obj.OrderID != nil {
		return repository.FindOrderItems(r.DB, *obj.OrderID)
	}

	return nil, nil
}

func (r *permissionResolver) Pricing(ctx context.Context, obj *model.Permission) (*model.Category, error) {
	if obj.PricingID != nil {
		return repository.FindCategory(r.DB, *obj.PricingID)
	}

	return nil, nil
}

func (r *permissionResolver) Creator(ctx context.Context, obj *model.Permission) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *permissionResolver) Role(ctx context.Context, obj *model.Permission) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *priceResolver) Creator(ctx context.Context, obj *model.Price) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *priceResolver) Category(ctx context.Context, obj *model.Price) (*model.Category, error) {
	return repository.FindCategory(r.DB, obj.CategoryID)
}

func (r *productResolver) Store(ctx context.Context, obj *model.Product) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *productResolver) Brands(ctx context.Context, obj *model.Product) ([]*model.Brand, error) {
	return repository.FindBrands(r.DB, model.BrandsArgs{
		ProductID: &obj.ID,
	}, helpers.ForContext(ctx).StoreID)
}

func (r *productResolver) Creator(ctx context.Context, obj *model.Product) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *productResolver) Categories(ctx context.Context, obj *model.Product) ([]*model.Category, error) {
	return repository.FindProductCategories(r.DB, model.CategoryTypeCategory, obj.ID)
}

func (r *productCategoryResolver) Category(ctx context.Context, obj *model.ProductCategory) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *productCategoryResolver) Product(ctx context.Context, obj *model.ProductCategory) (*model.Product, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *productCategoryResolver) Item(ctx context.Context, obj *model.ProductCategory) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *productCategoryResolver) Creator(ctx context.Context, obj *model.ProductCategory) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *queryResolver) Admin(ctx context.Context, id int) (*model.Admin, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Admins(ctx context.Context) ([]*model.Admin, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Brand(ctx context.Context, id int) (*model.Brand, error) {
	return repository.FindBrand(r.DB, id)
}

func (r *queryResolver) Brands(ctx context.Context, args model.BrandsArgs) ([]*model.Brand, error) {
	return repository.FindBrands(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Category(ctx context.Context, id int) (*model.Category, error) {
	return repository.FindCategory(r.DB, id)
}

func (r *queryResolver) Categories(ctx context.Context) ([]*model.Category, error) {
	return repository.FindCategories(r.DB, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) CurrentStore(ctx context.Context) (*model.Store, error) {
	return repository.FindStaffStore(r.DB, helpers.UserAndStoreArgs{
		UserID:  helpers.ForContext(ctx).UserID,
		StoreID: helpers.ForContext(ctx).StoreID,
	})
}

func (r *queryResolver) Customer(ctx context.Context, id int) (*model.Customer, error) {
	return repository.FindCustomer(r.DB, id)
}

func (r *queryResolver) Customers(ctx context.Context) ([]*model.Customer, error) {
	return repository.FindCustomers(r.DB, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Item(ctx context.Context, id int) (*model.Item, error) {
	return repository.FindItem(r.DB, id)
}

func (r *queryResolver) Items(ctx context.Context, args model.ItemsArgs) ([]*model.Item, error) {
	return repository.FindItems(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Expense(ctx context.Context, id int) (*model.Expense, error) {
	return repository.FindExpense(r.DB, id)
}

func (r *queryResolver) Expenses(ctx context.Context, args model.ExpensesArgs) ([]*model.Expense, error) {
	return repository.FindExpenses(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Me(ctx context.Context) (*model.User, error) {
	return repository.FindUser(r.DB, helpers.ForContext(ctx).UserID)
}

func (r *queryResolver) Order(ctx context.Context, id int) (*model.Order, error) {
	return repository.FindOrder(r.DB, id)
}

func (r *queryResolver) Orders(ctx context.Context, args model.OrdersArgs) ([]*model.Order, error) {
	return repository.FindOrders(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Payment(ctx context.Context, id int) (*model.Payment, error) {
	return repository.FindPayment(r.DB, id)
}

func (r *queryResolver) Payments(ctx context.Context, args model.PaymentsArgs) ([]*model.Payment, error) {
	return repository.FindPayments(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Permission(ctx context.Context, id int) (*model.Permission, error) {
	return repository.FindPermission(r.DB, id)
}

func (r *queryResolver) Permissions(ctx context.Context, roleID int) ([]*model.Permission, error) {
	return repository.FindPermissions(r.DB, roleID)
}

func (r *queryResolver) Product(ctx context.Context, id int) (*model.Product, error) {
	return repository.FindProduct(r.DB, id, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Products(ctx context.Context, args model.ProductsArgs) ([]*model.Product, error) {
	return repository.FindProducts(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Sales(ctx context.Context, args model.StatsArgs) ([]*model.OrderItem, error) {
	return repository.FindSoldItems(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) Staff(ctx context.Context, id int) (*model.Staff, error) {
	return repository.FindStaff(r.DB, id)
}

func (r *queryResolver) Staffs(ctx context.Context, args *model.StaffsArgs) ([]*model.Staff, error) {
	return repository.FindStaffs(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Store(ctx context.Context, id int) (*model.Store, error) {
	return repository.FindStore(r.DB, id)
}

func (r *queryResolver) Stores(ctx context.Context) ([]*model.Store, error) {
	return repository.FindStores(r.DB, helpers.ForContext(ctx).UserID)
}

func (r *queryResolver) Unit(ctx context.Context, id int) (*model.Unit, error) {
	return repository.FindUnit(r.DB, id)
}

func (r *queryResolver) Units(ctx context.Context) ([]*model.Unit, error) {
	return repository.FindUnits(r.DB, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) User(ctx context.Context, id int) (*model.User, error) {
	return repository.FindUser(r.DB, id)
}

func (r *queryResolver) Users(ctx context.Context, args model.UsersArgs) ([]*model.User, error) {
	return repository.FindUsers(r.DB, args)
}

func (r *queryResolver) NetIncome(ctx context.Context, args model.StatsArgs) (string, error) {
	return repository.SumNetIncome(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) DailyGrossProfits(ctx context.Context, args model.StatsArgs) ([]*model.Profit, error) {
	return repository.SumGrossProfitsByDay(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) GrossProfit(ctx context.Context, args model.StatsArgs) (*model.Profit, error) {
	return repository.SumGrossProfit(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) TotalExpensesAmount(ctx context.Context, args model.StatsArgs) (string, error) {
	return repository.SumExpensePayment(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) TotalSalesAmount(ctx context.Context, args model.StatsArgs) (string, error) {
	return repository.SumOrderPayments(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) AverageDailySalesAmount(ctx context.Context, args model.StatsArgs) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) ItemsStats(ctx context.Context) ([]*model.ItemsStats, error) {
	return repository.SumItemsCost(r.DB, helpers.ForContext(ctx).StoreID)
}

func (r *staffResolver) Role(ctx context.Context, obj *model.Staff) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *staffResolver) User(ctx context.Context, obj *model.Staff) (*model.User, error) {
	return repository.FindUser(r.DB, obj.UserID)
}

func (r *staffResolver) Creator(ctx context.Context, obj *model.Staff) (*model.User, error) {
	if obj.CreatorID != nil {
		return repository.FindUser(r.DB, *obj.CreatorID)
	}
	return nil, nil
}

func (r *staffResolver) Permissions(ctx context.Context, obj *model.Staff) ([]*model.Permission, error) {
	return repository.FindPermissions(r.DB, obj.RoleID)
}

func (r *storeResolver) User(ctx context.Context, obj *model.Store) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *storeResolver) Permissions(ctx context.Context, obj *model.Store) ([]*model.Permission, error) {
	return repository.FindPermissions(r.DB, helpers.ForContext(ctx).RoleID)
}

func (r *subscriptionResolver) Item(ctx context.Context) (<-chan *model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *subscriptionResolver) Order(ctx context.Context) (<-chan *model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *subscriptionResolver) Payment(ctx context.Context) (<-chan *model.Payment, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *subscriptionResolver) NetProfit(ctx context.Context, args model.StatsArgs) (<-chan string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *subscriptionResolver) TotalExpensesAmount(ctx context.Context, args model.StatsArgs) (<-chan string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *subscriptionResolver) TotalSalesAmount(ctx context.Context, args model.StatsArgs) (<-chan string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *unitResolver) User(ctx context.Context, obj *model.Unit) (*model.User, error) {
	return repository.FindUser(r.DB, *obj.UserID)
}

func (r *userResolver) Password(ctx context.Context, obj *model.User) (*string, error) {
	return nil, errors.New("field is not accessible")
}

// Admin returns generated.AdminResolver implementation.
func (r *Resolver) Admin() generated.AdminResolver { return &adminResolver{r} }

// AuthPayload returns generated.AuthPayloadResolver implementation.
func (r *Resolver) AuthPayload() generated.AuthPayloadResolver { return &authPayloadResolver{r} }

// Brand returns generated.BrandResolver implementation.
func (r *Resolver) Brand() generated.BrandResolver { return &brandResolver{r} }

// Category returns generated.CategoryResolver implementation.
func (r *Resolver) Category() generated.CategoryResolver { return &categoryResolver{r} }

// Customer returns generated.CustomerResolver implementation.
func (r *Resolver) Customer() generated.CustomerResolver { return &customerResolver{r} }

// Expense returns generated.ExpenseResolver implementation.
func (r *Resolver) Expense() generated.ExpenseResolver { return &expenseResolver{r} }

// Item returns generated.ItemResolver implementation.
func (r *Resolver) Item() generated.ItemResolver { return &itemResolver{r} }

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Order returns generated.OrderResolver implementation.
func (r *Resolver) Order() generated.OrderResolver { return &orderResolver{r} }

// OrderItem returns generated.OrderItemResolver implementation.
func (r *Resolver) OrderItem() generated.OrderItemResolver { return &orderItemResolver{r} }

// Payment returns generated.PaymentResolver implementation.
func (r *Resolver) Payment() generated.PaymentResolver { return &paymentResolver{r} }

// Permission returns generated.PermissionResolver implementation.
func (r *Resolver) Permission() generated.PermissionResolver { return &permissionResolver{r} }

// Price returns generated.PriceResolver implementation.
func (r *Resolver) Price() generated.PriceResolver { return &priceResolver{r} }

// Product returns generated.ProductResolver implementation.
func (r *Resolver) Product() generated.ProductResolver { return &productResolver{r} }

// ProductCategory returns generated.ProductCategoryResolver implementation.
func (r *Resolver) ProductCategory() generated.ProductCategoryResolver {
	return &productCategoryResolver{r}
}

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

// Staff returns generated.StaffResolver implementation.
func (r *Resolver) Staff() generated.StaffResolver { return &staffResolver{r} }

// Store returns generated.StoreResolver implementation.
func (r *Resolver) Store() generated.StoreResolver { return &storeResolver{r} }

// Subscription returns generated.SubscriptionResolver implementation.
func (r *Resolver) Subscription() generated.SubscriptionResolver { return &subscriptionResolver{r} }

// Unit returns generated.UnitResolver implementation.
func (r *Resolver) Unit() generated.UnitResolver { return &unitResolver{r} }

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type adminResolver struct{ *Resolver }
type authPayloadResolver struct{ *Resolver }
type brandResolver struct{ *Resolver }
type categoryResolver struct{ *Resolver }
type customerResolver struct{ *Resolver }
type expenseResolver struct{ *Resolver }
type itemResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
type orderResolver struct{ *Resolver }
type orderItemResolver struct{ *Resolver }
type paymentResolver struct{ *Resolver }
type permissionResolver struct{ *Resolver }
type priceResolver struct{ *Resolver }
type productResolver struct{ *Resolver }
type productCategoryResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type staffResolver struct{ *Resolver }
type storeResolver struct{ *Resolver }
type subscriptionResolver struct{ *Resolver }
type unitResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
