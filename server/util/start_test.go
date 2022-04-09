package util_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/util"
	"testing"
)

func TestStartServer(t *testing.T) {
	t.Run("Online", func(t *testing.T) {
		result := util.StartServer(false)
		require.Greater(t, result, 8080)
	})

	t.Run("Offline", func(t *testing.T) {
		result := util.StartServer(true)
		require.Greater(t, result, 8080)
	})
}
