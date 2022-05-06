package util

import (
	"context"
	"mahesabu/graph/model"
	"net/http"
)

// A private key for context that only this package can access. This is important
// to prevent collisions between different context uses
var userCtxKey = &contextKey{"user"}

type contextKey struct {
	userId string
}

// Auth A stand-in for our database backed user object
// todo inject this to every resolver.
type Auth struct {
	UserId  int
	StoreId int
	Role    model.StaffRole
}

// AuthMiddleware decodes the share session cookie and packs the session into context
func AuthMiddleware() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			c, err := r.Cookie("Authorization")

			// Allow unauthenticated users in
			if err != nil || c == nil {
				next.ServeHTTP(w, r)
				return
			}

			//token := c.Value

			auth := Auth{
				UserId:  1,
				StoreId: 1,
				Role:    model.StaffRoleStaff,
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
func ForContext(ctx context.Context) *Auth {
	raw, _ := ctx.Value(userCtxKey).(*Auth)
	return raw
}
