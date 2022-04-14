package util_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/util"
	"testing"
)

func TestStartServer(t *testing.T) {
	t.Run("Online", func(t *testing.T) {
		result := util.StartServer(util.StartServerArgs{
			Offline: true,
		})
		require.Greater(t, result, 6060)
	})

	t.Run("Offline", func(t *testing.T) {
		result := util.StartServer(util.StartServerArgs{
			Port:    "7070",
			Offline: true,
		})
		require.Greater(t, result, 7070)
	})
}
