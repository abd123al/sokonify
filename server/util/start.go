package util

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"log"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"net/http"
	"os"
)

const defaultPort = "8080"

// StartServer This way so that it can be invoked via libs
func StartServer(Offline bool) string {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	db := InitDB(InitDbArgs{
		DbName:  "mahesabu",
		Clear:   false,
		Offline: Offline,
		Mobile:  Offline,
	})

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:     db,
		UserId: 1,
	}}

	//Configuring directives to be used on run-time
	config.Directives.HasRole = HasRole

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(config))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))

	return port
}
