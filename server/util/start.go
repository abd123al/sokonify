package util

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/handler/extension"
	"github.com/99designs/gqlgen/graphql/handler/transport"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi"
	"github.com/go-chi/jwtauth"
	"log"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"mahesabu/helpers"
	"net/http"
	"os"
)

type StartServerArgs struct {
	Offline bool
	Port    string
}

// StartServer This way so that it can be invoked via libs
func StartServer(Args StartServerArgs) string {
	port := os.Getenv("PORT")

	if port == "" {
		if Args.Port == "" {
			port = "8080"
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

	//jwt: Seek, verify and validate JWT tokens
	router.Use(jwtauth.Verifier(helpers.TokenAuth))
	router.Use(Authenticator)

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:     db,
		UserId: 1,
	}}

	//Configuring directives to be used on run-time
	config.Directives.HasRole = HasRole
	config.Directives.IsAuthenticated = IsAuthenticated
	config.Directives.Validate = Validator

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
