package util

import (
	"github.com/go-chi/jwtauth"
	"github.com/lestrrat-go/jwx/jwt"
	"net/http"
)

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

		// Otherwise continue
		next.ServeHTTP(w, r)
	})
}
