package util

import (
	"context"
	"net/http"
)

//func Authenticator(next http.Handler) http.Handler {
//	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
//		token, _, _ := jwtauth.FromContext(r.Context())
//
//		//If token is available validate it.
//		if token != nil {
//			if err := jwt.Validate(token); err != nil {
//				http.Error(w, err.Error(), 401)
//				return
//			}
//		}
//
//		// Otherwise continue
//		next.ServeHTTP(w, r)
//	})
//}

type HTTP struct {
	W *http.ResponseWriter
}

type contextKey struct {
	name string
}

var HTTPCtxKey = &contextKey{"NuxResponseWriter"}

// Authenticator This seems like not a good solution
// https://stackoverflow.com/questions/67638302/use-responsewriter-anywhere-in-golang-application-middleware
func Authenticator(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		//Here I am Injecting ResponseWriter to the context
		b := context.WithValue(r.Context(), HTTPCtxKey, HTTP{W: &w})
		r = r.WithContext(b)

		// Otherwise continue
		next.ServeHTTP(w, r)
	})
}
