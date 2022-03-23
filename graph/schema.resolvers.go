package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
)

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	item := model.Item{
		Quantity: input.Quantity,
	}
	r.DB.Create(&item)
	return &item, nil
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

func (r *mutationResolver) EditItem(ctx context.Context, id int, input model.ItemInput) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) DeleteItem(ctx context.Context, id int) (*model.Item, error) {
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

func (r *queryResolver) Store(ctx context.Context, id int) (*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Stores(ctx context.Context) ([]*model.Store, error) {
	panic(fmt.Errorf("not implemented"))
}

// Mutation returns generated.MutationResolver implementation.
func (r *Resolver) Mutation() generated.MutationResolver { return &mutationResolver{r} }

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
