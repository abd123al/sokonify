package helpers

import "github.com/go-chi/jwtauth"

var TokenAuth = jwtauth.New("HS256", []byte("secret123"), nil)
