package helpers_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"testing"
)

func TestGenerateAuthToken(t *testing.T) {
	t.Run("GenerateAuthToken with store", func(t *testing.T) {
		perm := model.PermissionTypeCreateOrder
		pricingId := 1

		token := helpers.GenerateAuthToken(1, &helpers.FindDefaultStoreAndRoleResult{
			StoreID: 2,
			RoleID:  4,
			Permissions: []*model.Permission{
				{
					ID:         1,
					Permission: &perm,
				},
				{
					ID:        2,
					PricingID: &pricingId,
				},
			},
		})

		fmt.Printf("token: %s\n\n", token)
		decoded, _ := helpers.TokenAuth.Decode(token)

		params := helpers.ExtractAuthParams(decoded.PrivateClaims())
		fmt.Printf("%v\n\n", params)

		require.NotNil(t, token)
	})

	t.Run("GenerateAuthToken with no store", func(t *testing.T) {
		result := helpers.GenerateAuthToken(1, nil)

		fmt.Printf("%s\n\n", result)

		require.NotNil(t, result)
	})
}
