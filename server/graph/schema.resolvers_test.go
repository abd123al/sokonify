package graph_test

import (
	"github.com/99designs/gqlgen/client"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/require"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
	"mahesabu/util"
	"testing"
)

func TestResolvers(t *testing.T) {
	DB := util.InitDB(util.InitDbArgs{
		DbName:  "mahesabu_test",
		Clear:   true,
		Offline: false,
	})

	user := util.CreateUser(DB)
	store := util.CreateStore(DB, user.ID)
	_ = util.CreateStaff(DB, util.CreateStaffArgs{
		UserID:  user.ID,
		StoreID: store.ID,
	})
	category := util.CreateCategory(DB, store.ID)
	product := util.CreateProduct(DB, category.ID)
	item := util.CreateItem(DB, util.CreateItemArgs{
		ProductID: product.ID,
	})
	order := util.CreateOrder(DB, util.CreateOrderArgs{
		IssuerID: store.ID,
		UserId:   user.ID,
		ItemID:   item.ID,
	})

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:     DB,
		UserId: user.ID,
	}}

	config.Directives.HasRole = util.HasRole

	//Graphql client
	c := client.New(handler.NewDefaultServer(generated.NewExecutableSchema(config)))

	t.Run("ping", func(t *testing.T) {
		var resp struct {
			Ping string
		}

		c.MustPost(`mutation { ping }`, &resp)

		require.Equal(t, "pong", resp.Ping)
	})

	t.Run("createUser", func(t *testing.T) {
		var resp struct {
			CreateUser model.User
		}
		fake := model.User{}
		_ = faker.FakeData(&fake)

		input := model.UserInput{
			Username: fake.Username,
			Email:    fake.Email,
			Name:     fake.Name,
			Password: fake.Password,
		}

		c.MustPost(`
			mutation createUser($input: UserInput!) {
			  createUser(input: $input) {
				username
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.Username, resp.CreateUser.Username)
	})

	t.Run("createStore", func(t *testing.T) {
		var resp struct {
			CreateStore model.Store
		}

		input := model.StoreInput{
			Name: "store",
		}

		c.MustPost(`
			mutation createUser($input: StoreInput!) {
			  createStore(input: $input) {
				name
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.Name, resp.CreateStore.Name)
	})

	t.Run("CreateStaff", func(t *testing.T) {
		//todo don't allow duplicates in store staff
		newStore := util.CreateStore(DB, user.ID)

		var resp struct {
			CreateStaff model.Staff
		}

		input := model.StaffInput{
			StoreID: newStore.ID,
			UserID:  user.ID,
		}

		c.MustPost(`
			mutation createStaff($input: StaffInput!) {
			  createStaff(input: $input) {
				userId
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.UserID, resp.CreateStaff.UserID)
	})

	t.Run("CreateCategory", func(t *testing.T) {
		var resp struct {
			CreateCategory model.Category
		}

		unit := "tabs"
		categoryType := model.CategoryTypeProducts

		input := model.CategoryInput{
			Name:    "Tablets",
			Unit:    &unit,
			Type:    &categoryType,
			StoreID: store.ID,
		}

		c.MustPost(`
			mutation createCategory($input: CategoryInput!) {
			  createCategory(input: $input) {
				name
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.Name, resp.CreateCategory.Name)
	})

	t.Run("CreateProduct", func(t *testing.T) {
		var resp struct {
			CreateProduct model.Product
		}

		input := model.ProductInput{
			Brands: []*model.ProductBrandInput{
				{Name: "74774"},
				{Name: "23445"},
			},
			Name:       "Product Name",
			CategoryID: category.ID,
		}

		c.MustPost(`
			mutation createProduct($input: ProductInput!) {
			  createProduct(input: $input) {
				name
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.Name, resp.CreateProduct.Name)
	})

	t.Run("CreateBrand", func(t *testing.T) {
		var resp struct {
			CreateBrand model.Brand
		}

		input := model.BrandInput{
			Name:      "Product Name",
			ProductID: product.ID,
		}

		c.MustPost(`
			mutation createBrand($input: BrandInput!) {
			  createBrand(input: $input) {
				name
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.Name, resp.CreateBrand.Name)
	})

	t.Run("CreateOrder", func(t *testing.T) {
		var resp struct {
			CreateOrder model.Order
		}

		input := model.OrderInput{
			Items: []*model.OrderItemInput{
				{Quantity: 2, Price: "74774", ItemID: item.ID},
				{Quantity: 5, Price: "23445", ItemID: item.ID},
			},
			Type:       model.OrderTypeSale,
			CustomerID: &user.ID,
			IssuerID:   store.ID,
		}

		c.MustPost(`
			mutation createOrder($input: OrderInput!) {
			  createOrder(input: $input) {
				customerId
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, input.CustomerID, resp.CreateOrder.CustomerID)
	})

	t.Run("CreatePayment", func(t *testing.T) {
		var resp struct {
			CreatePayment model.Payment
		}

		input := model.PaymentInput{
			Type:    model.PaymentTypeCash,
			OrderID: order.ID,
		}

		c.MustPost(`
			mutation createPayment($input: PaymentInput!) {
			  createPayment(input: $input) {
				amount
			  }
			}
			`, &resp,
			client.Var("input", input))

		require.Equal(t, "26001.54", resp.CreatePayment.Amount)
	})

	//Queries

	t.Run("Stores", func(t *testing.T) {
		var resp struct {
			Stores []model.Store
		}

		c.MustPost(`
				{
				  stores {
					name
				  }
				}
			`, &resp)

		require.GreaterOrEqual(t, len(resp.Stores), 1)
	})
}
