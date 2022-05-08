package util

import (
	"context"
	"fmt"
	"github.com/99designs/gqlgen/graphql"
	"github.com/go-playground/validator/v10"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

var (
	validate *validator.Validate
)

func init() {
	validate = validator.New()
}

// Validator https://david-yappeter.medium.com/gqlgen-custom-data-validation-part-1-7de8ef92de4c
var Validator = func(ctx context.Context, obj interface{}, next graphql.Resolver, constraint string) (res interface{}, err error) {
	val, err := next(ctx)
	if err != nil {
		panic(err)
	}

	err = validate.Var(val, constraint)

	if err != nil {
		return nil, err
	}

	return val, nil
}

var HasRole = func(ctx context.Context, obj interface{}, next graphql.Resolver, userType model.StaffRole) (interface{}, error) {
	//if true {
	//	// block calling the next resolver
	//	return nil, fmt.Errorf("access denied")
	//}

	// or let it pass through
	return next(ctx)
}

var IsAuthenticated = func(ctx context.Context, obj interface{}, next graphql.Resolver) (res interface{}, err error) {
	payload := helpers.ForContext(ctx)

	if payload == nil {
		return nil, fmt.Errorf("access denied")
	}

	return next(ctx)
}
