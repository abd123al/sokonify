package util

import (
	"context"
	"github.com/go-chi/jwtauth"
	"github.com/lestrrat-go/jwx/jwt"
	"mahesabu/graph/model"
	"net/http"
)

// A private key for context that only this package can access. This is important
// to prevent collisions between different context uses
var userCtxKey = &contextKey{"user"}

type contextKey struct {
	userId string
}

func Authenticator(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token, _, _ := jwtauth.FromContext(r.Context())

		//If token is available validate it.
		if token != nil {
			if err := jwt.Validate(token); err != nil {
				http.Error(w, err.Error(), 401)
				return
			}
		}

		// Token is authenticated, pass it through
		next.ServeHTTP(w, r)
	})
}

// AuthMiddleware decodes the share session cookie and packs the session into context
func AuthMiddleware() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			c := r.Header["Authorization"][0]

			// Allow unauthenticated users in
			if c == "" {
				next.ServeHTTP(w, r)
				return
			}

			auth := model.AuthParams{
				UserID: 1,
			}

			// put it in context
			ctx := context.WithValue(r.Context(), userCtxKey, auth)

			// and call the next with our new context
			r = r.WithContext(ctx)
			next.ServeHTTP(w, r)
		})
	}
}

// ForContext finds the user from the context. REQUIRES Middleware to have run.
func ForContext(ctx context.Context) *model.AuthParams {
	raw, _ := ctx.Value(jwtauth.TokenCtxKey).(*model.AuthParams)
	return raw
}
