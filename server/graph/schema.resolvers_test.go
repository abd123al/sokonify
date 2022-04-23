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
	DB := util.InitTestDB()

	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)
	customer := util.CreateCustomer(DB, store.ID)
	staff := util.CreateStaff(DB, util.CreateStaffArgs{
		UserID:  user.ID,
		StoreID: store.ID,
	})
	category := util.CreateCategory(DB, store.ID)
	product := util.CreateProduct(DB, &util.CreateProductArgs{
		StoreID:    store.ID,
		CategoryId: &category.ID,
	})
	item := util.CreateItem(DB, &util.CreateItemArgs{
		ProductID: product.ID,
	})
	order := util.CreateOrder(DB, util.CreateOrderArgs{
		IssuerID:   store.ID,
		UserId:     user.ID,
		ItemID:     item.ID,
		CustomerID: customer.ID,
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

		password := "password"

		input := model.UserInput{
			Username: faker.Username(),
			Email:    faker.Email(),
			Name:     faker.Name(),
			Password: &password,
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

	t.Run("createStaff", func(t *testing.T) {
		//todo don't allow duplicates in store staff
		newStore := util.CreateStore(DB, &user.ID)

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

	t.Run("createCategory", func(t *testing.T) {
		var resp struct {
			CreateCategory model.Category
		}

		input := model.CategoryInput{
			Name:    "Tablets",
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

	t.Run("createCustomer", func(t *testing.T) {
		var resp struct {
			CreateCustomer model.Customer
		}

		gender := model.GenderTypeMale

		input := model.CustomerInput{
			Name:    "Tablets",
			Type:    model.CustomerTypeCustomer,
			StoreID: store.ID,
			Gender:  &gender,
		}

		var call = func(input model.CustomerInput) {
			c.MustPost(`
			mutation createCategory($input: CustomerInput!) {
			  createCustomer(input: $input) {
				name
			  }
			}
			`, &resp,
				client.Var("input", input))
		}

		//Without user email
		call(input)
		require.Equal(t, input.Name, resp.CreateCustomer.Name)

		//With user email so user will be set
		input.Email = &user.Email
		call(input)
		require.Equal(t, input.Name, resp.CreateCustomer.Name)

		//Some tricks so that we may be able to find user via phone
		input.Phone = &user.Phone
		input.Email = nil
		call(input)
		require.Equal(t, input.Name, resp.CreateCustomer.Name)
	})

	t.Run("createProduct", func(t *testing.T) {
		var resp struct {
			CreateProduct model.Product
		}

		input := model.ProductInput{
			Brands: []*model.ProductBrandInput{
				{Name: "74774"},
				{Name: "23445"},
			},
			Name:       "Product Name",
			Categories: []int{category.ID},
			Unit:       "tabs",
			Type:       model.ProductTypeProduct,
			StoreID:    store.ID,
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

	t.Run("createBrand", func(t *testing.T) {
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

	t.Run("createOrder", func(t *testing.T) {
		var resp struct {
			CreateOrder model.Order
		}

		input := model.OrderInput{
			Items: []*model.OrderItemInput{
				{Quantity: 2, Price: "74774", ItemID: item.ID},
				{Quantity: 5, Price: "23445", ItemID: item.ID},
			},
			Type:       model.OrderTypeSale,
			CustomerID: &customer.ID,
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

	t.Run("createPayment", func(t *testing.T) {
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

	t.Run("stores", func(t *testing.T) {
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

	t.Run("categories", func(t *testing.T) {
		var resp struct {
			Categories []model.Category
		}

		c.MustPost(`
				query categories($storeId: ID!) {
				  categories(storeId: $storeId) {
					id
					name
				  }
				}
			`, &resp, client.Var("storeId", store.ID))

		require.GreaterOrEqual(t, len(resp.Categories), 1)
	})

	t.Run("customers", func(t *testing.T) {
		var resp struct {
			Customers []model.Customer
		}

		c.MustPost(`
				query customers($storeId: ID!) {
				  customers(storeId: $storeId) {
					id
				  }
				}
			`, &resp, client.Var("storeId", store.ID))

		require.GreaterOrEqual(t, len(resp.Customers), 1)
	})

	t.Run("products", func(t *testing.T) {
		var resp struct {
			Products []model.Product
		}

		c.MustPost(`
			query products($value: ID!) {
			  products(value: $value) {
				id
			  }
			}
			`, &resp, client.Var("value", store.ID))

		require.GreaterOrEqual(t, len(resp.Products), 1)

		//By category
		c.MustPost(`
				query products($value: ID!) {
				  products(by: category, value: $value) {
					id
				  }
				}
			`, &resp, client.Var("value", category.ID))

		require.GreaterOrEqual(t, len(resp.Products), 1)
	})

	t.Run("items", func(t *testing.T) {
		var resp struct {
			Items []model.Item
		}

		c.MustPost(`
				query items($value: ID!) {
				  items(value: $value) {
					id
					quantity
				  }
				}
			`, &resp, client.Var("value", store.ID))

		require.GreaterOrEqual(t, len(resp.Items), 1)
	})

	t.Run("orders", func(t *testing.T) {
		var resp struct {
			Orders []model.Order
		}

		//By store
		c.MustPost(`
				query orders($value: ID!) {
				  orders(args: {value: $value}) {
					id
				  }
				}
			`, &resp, client.Var("value", store.ID))

		require.GreaterOrEqual(t, len(resp.Orders), 1)

		//By staff
		c.MustPost(`
				query orders($value: ID!) {
				  orders(args: {by: staff, value: $value}) {
					id
				  }
				}
			`, &resp, client.Var("value", staff.UserID))

		require.GreaterOrEqual(t, len(resp.Orders), 1)

		//By customer
		c.MustPost(`
				query orders($value: ID!) {
				  orders(args: {by: customer, value: $value}) {
					id
				  }
				}
			`, &resp, client.Var("value", customer.ID))

		require.GreaterOrEqual(t, len(resp.Orders), 1)
	})
}
