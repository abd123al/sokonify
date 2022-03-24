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

func TestSchemaResolvers(t *testing.T) {
	db := util.InitDB("mahesabu_test")

	//todo move to data generator
	createUser := func() *model.User {
		user := model.User{}
		_ = faker.FakeData(&user)
		db.Create(&user)
		return &user
	}

	user := createUser()

	//Graphql client
	c := client.New(handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &graph.Resolver{
		DB:     db,
		UserId: user.ID,
	}})))

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
}
