package util

import (
	"fmt"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/handler/extension"
	"github.com/99designs/gqlgen/graphql/handler/transport"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi"
	"github.com/go-chi/jwtauth"
	"github.com/rs/cors"
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
	NoOfStores int64
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

	router := ConfigureGraphql(db, Args.NoOfStores, Args.IsServer, port)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe("127.0.0.1:"+port, router))

	return port
}

func ConfigureGraphql(DB *gorm.DB, NoOfStores int64, isServer bool, port string) *chi.Mux {
	router := chi.NewRouter()

	//todo websockets too https://gqlgen.com/recipes/cors/
	router.Use(cors.New(cors.Options{
		AllowedOrigins:   []string{fmt.Sprintf("http://localhost:%s", port), fmt.Sprintf("http://127.0.0.1:%s", port)},
		AllowCredentials: true,
		AllowedHeaders:   []string{"*"},
	}).Handler)

	//jwt: Seek, verify and validate JWT tokens
	router.Use(jwtauth.Verifier(helpers.TokenAuth))
	router.Use(Authenticator)
	router.Get("/status", StatusRouter)

	config := generated.Config{Resolvers: &graph.Resolver{
		DB:         DB,
		NoOfStores: NoOfStores,
	}}

	//Configuring directives to be used on run-time
	config.Directives.IsAuthenticated = IsAuthenticated
	config.Directives.HasPermission = HasPermission
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
