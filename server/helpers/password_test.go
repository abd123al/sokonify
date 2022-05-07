package helpers_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/helpers"
	"testing"
)

func TestHashPassword(t *testing.T) {
	t.Run("HashPassword", func(t *testing.T) {
		password := "p@$$w0rd"
		hash := helpers.HashPassword(password)
		match := helpers.VerifyPassword(password, hash)

		require.NotNil(t, hash)
		require.Equal(t, match, true)
	})
}
