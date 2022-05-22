package graph

//go:generate go run -mod=mod github.com/99designs/gqlgen generate
import (
	"gorm.io/gorm"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	DB         *gorm.DB
	Multistore bool
}
