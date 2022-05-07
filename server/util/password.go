package util

import (
	"github.com/alexedwards/argon2id"
)

func HashPassword(password string) string {
	hash, err := argon2id.CreateHash(password, argon2id.DefaultParams)
	if err != nil {
		panic(err)
	}

	return hash
}

func VerifyPassword(password string, hash string) bool {
	match, err := argon2id.ComparePasswordAndHash(password, hash)
	if err != nil {
		panic(err)
	}

	return match
}
