package lib_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/lib"
	"testing"
)

func TestStartServer(t *testing.T) {
	t.Run("Offline", func(t *testing.T) {
		result := lib.StartServer("", "9999")
		require.Equal(t, result, "9999")
	})
}
