package util

import (
	"context"
	"errors"
	"github.com/99designs/gqlgen/graphql"
	"github.com/bxcodec/faker/v3/support/slice"
	"github.com/go-chi/jwtauth"
	"github.com/go-playground/validator/v10"
	"github.com/lestrrat-go/jwx/jwt"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"net/http"
)

var (
	validate          *validator.Validate
	NoAccessError     = errors.New("no access")
	NoPermissionError = errors.New("you have no permission to perform this action")
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

func checkToken(ctx context.Context) error {
	token, _, err := jwtauth.FromContext(ctx)
	r := ctx.Value(HTTPCtxKey).(HTTP)

	//If token is available validate it.
	if err != nil || jwt.Validate(token) != nil {
		http.Error(*r.W, http.StatusText(401), http.StatusUnauthorized)
		return errors.New(http.StatusText(401))
	}

	return nil
}

var HasPermission = func(ctx context.Context, obj interface{}, next graphql.Resolver, permission model.PermissionType) (interface{}, error) {
	err := checkToken(ctx)
	if err != nil {
		return nil, err
	}

	payload := helpers.ForContext(ctx)

	if payload == nil {
		return nil, NoAccessError
	}

	//owner can do anything that other staffs can.
	//we check for store id because roles requires valid store
	if payload.StoreID != 0 {
		hasP := slice.Contains(payload.Permissions, permission.String())
		hasAll := slice.Contains(payload.Permissions, model.PermissionTypeAll.String())

		//todo What if owner transfer ownership?
		if payload.IsOwner || hasP || hasAll {
			return next(ctx)
		}
	}

	return nil, NoPermissionError
}

var IsAuthenticated = func(ctx context.Context, obj interface{}, next graphql.Resolver) (res interface{}, err error) {
	err = checkToken(ctx)
	if err != nil {
		return nil, err
	}

	payload := helpers.ForContext(ctx)

	if payload == nil {
		return nil, NoAccessError
	}

	return next(ctx)
}
