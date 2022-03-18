package main

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"mahesabu/graph/model"
	"net/http"
	"os"
)

const defaultPort = "8080"

func main() {
	dsn := "host=localhost user=postgres password=password dbname=mahesabu port=5432 sslmode=disable TimeZone=Africa/Nairobi"
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn}))
	if err != nil {
		panic("failed to connect database")
	}

	err = db.AutoMigrate(&model.Employee{})
	if err != nil {
		panic("failed to auto migrate")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &graph.Resolver{}}))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
