package util_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/util"
	"testing"
)

func TestHashPassword(t *testing.T) {
	t.Run("HashPassword", func(t *testing.T) {
		password := "p@$$w0rd"
		hash := util.HashPassword(password)
		match := util.VerifyPassword(password, hash)

		require.NotNil(t, hash)
		require.Equal(t, match, true)
	})
}
