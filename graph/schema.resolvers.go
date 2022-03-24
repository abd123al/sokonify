package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
)

func (r *itemResolver) BuyingPrice(ctx context.Context, obj *model.Item) (*string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateBrand(ctx context.Context, input model.BrandInput) (*model.Brand, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateCategory(ctx context.Context, input model.CategoryInput) (*model.Category, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	item := model.Item{
		Quantity: input.Quantity,
	}
	r.DB.Create(&item)
	return &item, nil
}

func (r *mutationResolver) CreateOrder(ctx context.Context, input model.OrderInput) (*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateProduct(ctx context.Context, input model.ProductInput) (*model.Product, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateStaff(ctx context.Context, input model.StaffInput) (*model.Staff, error) {
	staff := model.Staff{
		StoreID: input.StoreID,
		UserID:  input.UserID,
	}
	r.DB.Create(&staff)
	return &staff, nil
}

func (r *mutationResolver) CreateStore(ctx context.Context, input model.StoreInput) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateUser(ctx context.Context, input model.UserInput) (*model.User, error) {
	user := model.User{
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Password: input.Password,
	}
	r.DB.Create(&user)
	return &user, nil
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

func (r *orderItemResolver) SubTotalPrice(ctx context.Context, obj *model.OrderItem) (string, error) {
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
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Item(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Items(ctx context.Context, storeID int) ([]*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Order(ctx context.Context, id int) (*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Orders(ctx context.Context, storeID int) ([]*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
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

func (r *queryResolver) Products(ctx context.Context, storeID int) ([]*model.Product, error) {
	panic(fmt.Errorf("not implemented"))
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
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) User(ctx context.Context, id int) (*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Users(ctx context.Context) ([]*model.User, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *userResolver) Password(ctx context.Context, obj *model.User) (*string, error) {
	return nil, nil
}

// Item returns generated.ItemResolver implementation.
func (r *Resolver) Item() generated.ItemResolver { return &itemResolver{r} }

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// OrderItem returns generated.OrderItemResolver implementation.
func (r *Resolver) OrderItem() generated.OrderItemResolver { return &orderItemResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type itemResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
type orderItemResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
