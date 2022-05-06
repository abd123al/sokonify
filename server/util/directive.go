package util

import (
	"context"
	"fmt"
	"github.com/99designs/gqlgen/graphql"
	"mahesabu/graph/model"
)

var HasRole = func(ctx context.Context, obj interface{}, next graphql.Resolver, userType model.StaffRole) (interface{}, error) {
	//if true {
	//	// block calling the next resolver
	//	return nil, fmt.Errorf("access denied")
	//}

	// or let it pass through
	return next(ctx)
}

var IsAuthenticated = func(ctx context.Context, obj interface{}, next graphql.Resolver) (res interface{}, err error) {
	ctxUserID := ctx.Value(userCtxKey)

	if ctxUserID == nil {
		return nil, fmt.Errorf("access denied")
	}

	return next(ctx)
}
