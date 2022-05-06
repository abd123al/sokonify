package util

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/handler/extension"
	"github.com/99designs/gqlgen/graphql/handler/transport"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi"
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

	router := chi.NewRouter()
	router.Use(AuthMiddleware())

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:     db,
		UserId: 1,
	}}

	//Configuring directives to be used on run-time
	config.Directives.HasRole = HasRole
	config.Directives.IsAuthenticated = IsAuthenticated

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(config))
	srv.AddTransport(transport.Options{})
	srv.AddTransport(transport.POST{})
	srv.Use(extension.Introspection{}) //todo disable when live

	router.Handle("/", playground.Handler("GraphQL playground", "/graphql"))
	router.Handle("/graphql", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, router))

	return port
}
