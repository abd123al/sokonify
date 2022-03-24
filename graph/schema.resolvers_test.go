package graph_test

import (
	"github.com/99designs/gqlgen/client"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/stretchr/testify/require"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
	"testing"
)

func TestSchemaResolvers(t *testing.T) {
	dsn := "host=localhost user=postgres password=password dbname=mahesabu_test port=5432 sslmode=disable TimeZone=Africa/Nairobi"
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn}))
	if err != nil {
		panic("failed to connect database")
	}

	db.Exec("DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO public;")

	err = db.AutoMigrate(
		&model.Staff{}, &model.Item{}, &model.Store{}, &model.Order{}, model.OrderItem{},
		&model.User{}, &model.Payment{}, &model.Ledger{}, &model.Product{}, &model.Brand{},
	)
	if err != nil {
		panic("failed to auto migrate")
	}
	c := client.New(handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &graph.Resolver{
		DB: db,
	}})))

	t.Run("ping", func(t *testing.T) {
		var resp struct {
			Ping string
		}

		c.MustPost(`mutation { ping }`, &resp)

		require.Equal(t, "pong", resp.Ping)
	})
}
