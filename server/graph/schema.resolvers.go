package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"time"
)

func (r *adminResolver) Password(ctx context.Context, obj *model.Admin) (*string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *itemResolver) BuyingPrice(ctx context.Context, obj *model.Item) (string, error) {
	return obj.BuyingPrice, nil
}

func (r *mutationResolver) CreateBrand(ctx context.Context, input model.BrandInput) (*model.Brand, error) {
	return repository.CreateBrand(r.DB, input)
}

func (r *mutationResolver) CreateCategory(ctx context.Context, input model.CategoryInput) (*model.Category, error) {
	return repository.CreateCategory(r.DB, input)
}

func (r *mutationResolver) CreateCustomer(ctx context.Context, input model.CustomerInput) (*model.Customer, error) {
	return repository.CreateCustomer(r.DB, input)
}

func (r *mutationResolver) CreateExpense(ctx context.Context, input model.ExpenseInput) (*model.Expense, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	return repository.CreateItem(r.DB, input)
}

func (r *mutationResolver) CreateOrder(ctx context.Context, input model.OrderInput) (*model.Order, error) {
	return repository.CreateOrder(r.DB, r.UserId, input)
}

func (r *mutationResolver) CreateOrderPayment(ctx context.Context, input model.OrderPaymentInput) (*model.Payment, error) {
	return repository.CreateOrderPayment(r.DB, r.UserId, input)
}

func (r *mutationResolver) CreateExpensePayment(ctx context.Context, input model.ExpensePaymentInput) (*model.Payment, error) {
	return repository.CreateExpensePayment(r.DB, r.UserId, input)
}

func (r *mutationResolver) CreateProduct(ctx context.Context, input model.ProductInput) (*model.Product, error) {
	return repository.CreateProduct(r.DB, input)
}

func (r *mutationResolver) CreateStaff(ctx context.Context, input model.StaffInput) (*model.Staff, error) {
	staff := model.Staff{
		StoreID: input.StoreID,
		UserID:  input.UserID,
	}
	result := r.DB.Create(&staff)
	return &staff, result.Error
}

func (r *mutationResolver) CreateStore(ctx context.Context, input model.StoreInput) (*model.Store, error) {
	//todo use transaction and save user as staff.
	store := model.Store{
		Name:    input.Name,
		OwnerID: r.UserId,
	}
	result := r.DB.Create(&store)
	return &store, result.Error
}

func (r *mutationResolver) CreateUser(ctx context.Context, input model.UserInput) (*model.User, error) {
	user := model.User{
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Password: input.Password,
	}
	result := r.DB.Create(&user)
	return &user, result.Error
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

func (r *mutationResolver) EditUser(ctx context.Context, id int, input model.UserInput) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) DeleteItem(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) Ping(ctx context.Context) (string, error) {
	return "pong", nil
}

func (r *mutationResolver) SignUp(ctx context.Context, input *model.UserInput) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
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
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Brands(ctx context.Context, productID int) ([]*model.Brand, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Category(ctx context.Context, id int) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Categories(ctx context.Context, storeID int) ([]*model.Category, error) {
	return repository.Categories(r.DB, storeID)
}

func (r *queryResolver) Customer(ctx context.Context, id int) (*model.Customer, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Customers(ctx context.Context, storeID int) ([]*model.Customer, error) {
	return repository.Customers(r.DB, storeID)
}

func (r *queryResolver) Item(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Items(ctx context.Context, by model.ItemsBy, value int) ([]*model.Item, error) {
	return repository.FindItems(r.DB, by, value)
}

func (r *queryResolver) Expense(ctx context.Context, id int) (*model.Expense, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Expenses(ctx context.Context, args model.ExpensesArgs) ([]*model.Expense, error) {
	return repository.FindExpenses(r.DB, args)
}

func (r *queryResolver) Order(ctx context.Context, id int) (*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Orders(ctx context.Context, args model.OrdersArgs) ([]*model.Order, error) {
	return repository.Orders(r.DB, args)
}

func (r *queryResolver) Payment(ctx context.Context, id int) (*model.Payment, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Payments(ctx context.Context, storeID int) ([]*model.Payment, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Product(ctx context.Context, id int) (*model.Product, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Products(ctx context.Context, by model.ProductsBy, value int) ([]*model.Product, error) {
	return repository.FindProducts(r.DB, by, value)
}

func (r *queryResolver) Staff(ctx context.Context, id int) (*model.Staff, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Staffs(ctx context.Context, storeID int) ([]*model.Staff, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Store(ctx context.Context, id int) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Stores(ctx context.Context) ([]*model.Store, error) {
	var stores []*model.Store
	result := r.DB.Table("stores").Joins("inner join staffs on staffs.store_id = stores.id AND staffs.user_id = ?", r.UserId).Find(&stores)
	return stores, result.Error
}

func (r *queryResolver) User(ctx context.Context, id int) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Users(ctx context.Context) ([]*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *statsResolver) Profit(ctx context.Context, obj *model.Stats, startDate time.Time, endDate time.Time) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *statsResolver) TotalSalesAmount(ctx context.Context, obj *model.Stats, startDate time.Time, endDate time.Time) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *statsResolver) TotalSalesItems(ctx context.Context, obj *model.Stats, startDate time.Time, endDate time.Time) (string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *userResolver) Password(ctx context.Context, obj *model.User) (*string, error) {
	return nil, nil
}

// Admin returns generated.AdminResolver implementation.
func (r *Resolver) Admin() generated.AdminResolver { return &adminResolver{r} }

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

// Stats returns generated.StatsResolver implementation.
func (r *Resolver) Stats() generated.StatsResolver { return &statsResolver{r} }

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type adminResolver struct{ *Resolver }
type itemResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
type orderResolver struct{ *Resolver }
type orderItemResolver struct{ *Resolver }
type productResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type statsResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
