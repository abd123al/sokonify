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
		result := helpers.GenerateAuthToken(1, &helpers.FindDefaultStoreAndRoleResult{
			StoreID: 1,
			Role:    model.StaffRoleOwner,
		})

		fmt.Printf("%s\n\n", result)

		require.NotNil(t, result)
	})

	t.Run("GenerateAuthToken with no store", func(t *testing.T) {
		result := helpers.GenerateAuthToken(1, nil)

		fmt.Printf("%s\n\n", result)

		require.NotNil(t, result)
	})
}
