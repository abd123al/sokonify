package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"

	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

func (r *adminResolver) Password(ctx context.Context, obj *model.Admin) (*string, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *itemResolver) BuyingPrice(ctx context.Context, obj *model.Item) (string, error) {
	return obj.BuyingPrice, nil
}

func (r *mutationResolver) CreateBrand(ctx context.Context, input model.BrandInput) (*model.Brand, error) {
	brand := model.Brand{
		Name:         input.Name,
		Manufacturer: input.Manufacturer,
		ProductID:    input.ProductID,
	}
	result := r.DB.Create(&brand)
	return &brand, result.Error
}

func (r *mutationResolver) CreateCategory(ctx context.Context, input model.CategoryInput) (*model.Category, error) {
	category := model.Category{
		Name:    input.Name,
		Unit:    *input.Unit,
		Type:    *input.Type,
		StoreID: input.StoreID,
	}
	result := r.DB.Create(&category)
	return &category, result.Error
}

func (r *mutationResolver) CreateCustomer(ctx context.Context, input model.CustomerInput) (*model.Customer, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *mutationResolver) CreateItem(ctx context.Context, input model.ItemInput) (*model.Item, error) {
	item := model.Item{
		Quantity: input.Quantity,
	}
	result := r.DB.Create(&item)
	return &item, result.Error
}

func (r *mutationResolver) CreateOrder(ctx context.Context, input model.OrderInput) (*model.Order, error) {
	var items []*model.OrderItem

	for _, k := range input.Items {
		item := model.OrderItem{
			Price:    k.Price,
			ItemID:   k.ItemID,
			Quantity: k.Quantity,
		}

		items = append(items, &item)
	}

	order := model.Order{
		ReceiverID: input.ReceiverID,
		IssuerID:   input.IssuerID,
		CustomerID: input.CustomerID,
		StaffID:    r.UserId,
		Type:       input.Type,
		Items:      items,
	}

	//fmt.Printf("%+v\n", order.Items[0].ItemID)

	result := r.DB.Create(&order)
	return &order, result.Error
}

func (r *mutationResolver) CreatePayment(ctx context.Context, input model.PaymentInput) (*model.Payment, error) {
	var payment *model.Payment

	err := r.DB.Transaction(func(tx *gorm.DB) error {
		//todo should the order creator be the one to confirm payment.
		var orderItems []model.OrderItem
		var subPrice decimal.Decimal

		tx.Where(&model.OrderItem{OrderID: input.OrderID}).Find(&orderItems)

		for _, o := range orderItems {
			price, err := decimal.NewFromString(o.Price)
			if err != nil {
				panic(err)
			}
			total := price.Mul(decimal.NewFromInt(int64(o.Quantity)))

			subPrice = subPrice.Add(total)
		}

		payment = &model.Payment{
			OrderID:     input.OrderID,
			Description: input.Description,
			ReferenceID: input.ReferenceID,
			Type:        input.Type,
			Amount:      subPrice.String(),
		}

		// do some database operations in the transaction (use 'tx' from this point, not 'db')
		if err := tx.Create(&payment).Error; err != nil {
			return err
		}

		// return nil will commit the whole transaction
		return nil
	})

	return payment, err
}

func (r *mutationResolver) CreateProduct(ctx context.Context, input model.ProductInput) (*model.Product, error) {
	var brands []*model.Brand

	for _, k := range input.Brands {
		brand := model.Brand{
			Manufacturer: k.Manufacturer,
			Name:         k.Name,
		}

		brands = append(brands, &brand)
	}

	product := model.Product{
		Name:       input.Name,
		CategoryID: input.CategoryID,
		Brands:     brands,
	}
	result := r.DB.Create(&product)
	return &product, result.Error
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
	var categories []*model.Category
	result := r.DB.Where(&model.Category{StoreID: storeID}).Find(&categories)
	return categories, result.Error
}

func (r *queryResolver) Customer(ctx context.Context, id int) (*model.Customer, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Customers(ctx context.Context, storeID int) ([]*model.Customer, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Item(ctx context.Context, id int) (*model.Item, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Items(ctx context.Context, by model.ItemsBy, value int) ([]*model.Item, error) {
	var items []*model.Item
	var result *gorm.DB

	if by == model.ItemsByStore {
		result = r.DB.Table("items").Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.store_id = ?", value).Find(&items)
	} else if by == model.ItemsByCategory {
		result = r.DB.Table("items").Joins("inner join products on products.id = items.product_id inner join categories on categories.id = products.category_id AND categories.id = ?", value).Find(&items)
	} else if by == model.ItemsByProduct {
		result = r.DB.Where(&model.Item{ProductID: value}).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return items, result.Error
}

func (r *queryResolver) Order(ctx context.Context, id int) (*model.Order, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryResolver) Orders(ctx context.Context, by model.OrdersBy, value int, limit int, offset int, sortBy model.SortBy, typeArg model.OrderType, status *model.OrderStatus) ([]*model.Order, error) {
	var orders []*model.Order
	var result *gorm.DB
	sort := "id " + "DESC" //todo use sortBy var

	//todo handle status
	if by == model.OrdersByStore {
		result = r.DB.Where(
			r.DB.Where(&model.Order{IssuerID: value}).Or(&model.Order{ReceiverID: &value})).Where(&model.Order{Type: typeArg}).Order(sort).Limit(limit).Offset(offset).Find(&orders)
	} else if by == model.OrdersByStaff {
		//Here StaffID is actually userId
		result = r.DB.Where(&model.Order{StaffID: value, Type: typeArg}).Order(sort).Limit(limit).Offset(offset).Find(&orders)
	} else if by == model.OrdersByCustomer {
		result = r.DB.Where(&model.Order{CustomerID: &value, Type: typeArg}).Order(sort).Limit(limit).Offset(offset).Find(&orders)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return orders, result.Error
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
	var items []*model.Product
	var result *gorm.DB

	if by == model.ProductsByStore {
		result = r.DB.Table("products").Joins("inner join categories on categories.id = products.category_id AND categories.store_id = ?", value).Find(&items)
	} else if by == model.ProductsByCategory {
		result = r.DB.Table("products").Joins("inner join categories on categories.id = products.category_id AND categories.id = ?", value).Find(&items)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return items, result.Error
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

// User returns generated.UserResolver implementation.
func (r *Resolver) User() generated.UserResolver { return &userResolver{r} }

type adminResolver struct{ *Resolver }
type itemResolver struct{ *Resolver }
type mutationResolver struct{ *Resolver }
type orderResolver struct{ *Resolver }
type orderItemResolver struct{ *Resolver }
type productResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type userResolver struct{ *Resolver }
