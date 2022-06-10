package util

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/handler/extension"
	"github.com/99designs/gqlgen/graphql/handler/transport"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi"
	"github.com/go-chi/jwtauth"
	"gorm.io/gorm"
	"log"
	"mahesabu/graph"
	"mahesabu/graph/generated"
	"mahesabu/helpers"
	"net/http"
	"os"
	"path/filepath"
)

type StartServerArgs struct {
	IsServer   bool
	Multistore bool
	Port       string
	Dsn        string //Especially for android
	IsRelease  bool
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
		DbName:    "mahesabu",
		Clear:     false,
		IsServer:  Args.IsServer,
		Dsn:       Args.Dsn,
		IsRelease: Args.IsRelease,
	})

	router := ConfigureGraphql(db, Args.Multistore, Args.IsServer)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, router))

	return port
}

func ConfigureGraphql(DB *gorm.DB, Multistore bool, isServer bool) *chi.Mux {
	router := chi.NewRouter()

	//jwt: Seek, verify and validate JWT tokens
	router.Use(jwtauth.Verifier(helpers.TokenAuth))
	router.Use(Authenticator)
	router.Get("/status", StatusRouter)

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:         DB,
		Multistore: Multistore,
	}}

	//Configuring directives to be used on run-time
	config.Directives.IsAuthenticated = IsAuthenticated
	config.Directives.HasRole = HasRole
	config.Directives.Validate = Validator

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(config))
	srv.AddTransport(transport.Options{})
	srv.AddTransport(transport.POST{})
	srv.Use(extension.Introspection{}) //todo disable when live

	router.Handle("/playground", playground.Handler("GraphQL playground", "/graphql"))
	router.Handle("/graphql", srv)

	if isServer {
		workDir, _ := os.Getwd()
		filesDir := http.Dir(filepath.Join(workDir, "web"))
		helpers.FileServer(router, "/", filesDir)
	}

	return router
}
