package helpers_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"testing"
)

func TestGenerateAuthToken(t *testing.T) {
	t.Run("GenerateAuthToken", func(t *testing.T) {
		user := model.User{
			ID: 1,
		}
		result := helpers.GenerateAuthToken(user)

		fmt.Printf("%s\n\n", result)

		require.NotNil(t, result)
	})
}
