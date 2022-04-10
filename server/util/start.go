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

type StartServerArgs struct {
	Offline bool
	Port    string
}

// StartServer This way so that it can be invoked via libs
func StartServer(Args StartServerArgs) string {
	port := os.Getenv("PORT")
	if port == "" {
		if Args.Port == "" {
			port = defaultPort
		} else {
			port = Args.Port
		}
	}

	db := InitDB(InitDbArgs{
		DbName:  "mahesabu",
		Clear:   false,
		Offline: Args.Offline,
		Mobile:  Args.Offline,
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
