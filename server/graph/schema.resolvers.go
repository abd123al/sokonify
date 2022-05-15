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

func (r *authPayloadResolver) Store(ctx context.Context, obj *model.AuthPayload) (*model.Store, error) {
	return repository.FindDefaultStore(r.DB, helpers.ForContext(ctx).UserID)
}

func (r *itemResolver) BuyingPrice(ctx context.Context, obj *model.Item) (string, error) {
	return obj.BuyingPrice, nil
}

func (r *mutationResolver) CreateBrand(ctx context.Context, input model.BrandInput) (*model.Brand, error) {
	return repository.CreateBrand(r.DB, input)
}

func (r *mutationResolver) CreateCategory(ctx context.Context, input model.CategoryInput) (*model.Category, error) {
	return repository.CreateCategory(r.DB, input, &helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateCustomer(ctx context.Context, input model.CustomerInput) (*model.Customer, error) {
	return repository.CreateCustomer(r.DB, input, helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateExpense(ctx context.Context, input model.ExpenseInput) (*model.Expense, error) {
	return repository.CreateExpense(r.DB, input, helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	return repository.CreateItem(r.DB, input)
}

func (r *mutationResolver) CreateOrder(ctx context.Context, input model.OrderInput) (*model.Order, error) {
	return repository.CreateOrder(r.DB, helpers.ForContext(ctx).UserID, input, helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateOrderPayment(ctx context.Context, input model.OrderPaymentInput) (*model.Payment, error) {
	return repository.CreateOrderPayment(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) CreateExpensePayment(ctx context.Context, input model.ExpensePaymentInput) (*model.Payment, error) {
	return repository.CreateExpensePayment(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) CreateProduct(ctx context.Context, input model.ProductInput) (*model.Product, error) {
	return repository.CreateProduct(r.DB, input, &helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateStaff(ctx context.Context, input model.StaffInput) (*model.Staff, error) {
	return repository.CreateStaff(r.DB, input, helpers.ForContext(ctx).StoreID)
}

func (r *mutationResolver) CreateStore(ctx context.Context, input model.StoreInput) (*model.Store, error) {
	return repository.CreateStore(r.DB, helpers.ForContext(ctx).UserID, input)
}

func (r *mutationResolver) CreateUnit(ctx context.Context, input model.UnitInput) (*model.Unit, error) {
	return repository.CreateUnit(r.DB, input, repository.CreateUnitsArgs{
		UserID:  &helpers.ForContext(ctx).UserID,
		StoreID: &helpers.ForContext(ctx).StoreID,
	})
}

func (r *mutationResolver) ChangePassword(ctx context.Context, input model.ChangePasswordInput) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditBrand(ctx context.Context, id int, input model.BrandInput) (*model.Brand, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditCategory(ctx context.Context, id int, input model.CategoryInput) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditCustomer(ctx context.Context, id int, input model.CustomerInput) (*model.Customer, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditItem(ctx context.Context, id int, input model.ItemInput) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditOrder(ctx context.Context, id int, input model.OrderInput) (*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditProduct(ctx context.Context, id int, input model.ProductInput) (*model.Product, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditStaff(ctx context.Context, id int, input model.StaffInput) (*model.Staff, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditStore(ctx context.Context, id int, input model.StoreInput) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) EditUnit(ctx context.Context, id int, input model.UnitInput) (*model.Unit, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) DeleteItem(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) Ping(ctx context.Context) (string, error) {
	return "pong", nil
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
	panic(fmt.Errorf("not implemented"))
}

func (r *orderResolver) Items(ctx context.Context, obj *model.Order) ([]*model.OrderItem, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *orderItemResolver) SubTotalPrice(ctx context.Context, obj *model.OrderItem) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *productResolver) Brands(ctx context.Context, obj *model.Product) ([]*model.Brand, error) {
	panic(fmt.Errorf("not implemented"))
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
	return repository.FindBrands(r.DB, args)
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
	return repository.FindPayments(r.DB, args)
}

func (r *queryResolver) Product(ctx context.Context, id int) (*model.Product, error) {
	return repository.FindProduct(r.DB, id)
}

func (r *queryResolver) Products(ctx context.Context, args model.ProductsArgs) ([]*model.Product, error) {
	return repository.FindProducts(r.DB, args, helpers.ForContext(ctx).StoreID)
}

func (r *queryResolver) Staff(ctx context.Context, id int) (*model.Staff, error) {
	return repository.FindStaff(r.DB, id)
}

func (r *queryResolver) Staffs(ctx context.Context) ([]*model.Staff, error) {
	return repository.FindStaffs(r.DB, helpers.ForContext(ctx).StoreID)
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

func (r *queryResolver) Users(ctx context.Context) ([]*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) NetIncome(ctx context.Context, args model.StatsArgs) (string, error) {
	return repository.SumNetProfit(r.DB, helpers.ForContext(ctx).StoreID, args)
}

func (r *queryResolver) GrossIncome(ctx context.Context, args model.StatsArgs) (string, error) {
	return repository.SumNetProfit(r.DB, helpers.ForContext(ctx).StoreID, args)
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

func (r *queryResolver) TotalItemsCost(ctx context.Context) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) TotalItemsRevenue(ctx context.Context) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) NetItemsIncome(ctx context.Context) (string, error) {
	panic(fmt.Errorf("not implemented"))
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

func (r *userResolver) Password(ctx context.Context, obj *model.User) (*string, error) {
	return nil, errors.New("field is accessible")
}

// Admin returns generated.AdminResolver implementation.
func (r *Resolver) Admin() generated.AdminResolver { return &adminResolver{r} }

// AuthPayload returns generated.AuthPayloadResolver implementation.
func (r *Resolver) AuthPayload() generated.AuthPayloadResolver { return &authPayloadResolver{r} }

// Item returns generated.ItemResolver implementation.
func (r *Resolver) Item() generated.ItemResolver { return &itemResolver{r} }

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Order returns generated.OrderResolver implementation.
func (r *Resolver) Order() generated.OrderResolver { return &orderResolver{r} }

// OrderItem returns generated.OrderItemResolver implementation.
func (r *Resolver) OrderItem() generated.OrderItemResolver { return &orderItemResolver{r} }

// Product returns generated.ProductResolver implementation.
func (r *Resolver) Product() generated.ProductResolver { return &productResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

// Subscription returns generated.SubscriptionResolver implementation.
func (r *Resolver) Subscription() generated.SubscriptionResolver { return &subscriptionResolver{r} }

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type adminResolver struct{ *Resolver }
type authPayloadResolver struct{ *Resolver }
type itemResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
type orderResolver struct{ *Resolver }
type orderItemResolver struct{ *Resolver }
type productResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type subscriptionResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
