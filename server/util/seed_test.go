package util_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/util"
	"testing"
)

func TestSeed(t *testing.T) {
	t.Run("Seed", func(t *testing.T) {
		result := util.Seed()

		fmt.Println(result)
		require.NotEmpty(t, result)
		require.NotEmpty(t, result[0])
		require.NotEmpty(t, result)
	})
}
