package helpers_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/helpers"
	"testing"
	"time"
)

func TestDate(t *testing.T) {
	t.Run("BeginningOfDay", func(t *testing.T) {
		result := helpers.BeginningOfDay(time.Now())

		fmt.Printf("BeginningOfDay: %s\n", result)

		require.NotNil(t, result)
	})

	t.Run("EndOfDay", func(t *testing.T) {
		result := helpers.EndOfDay(time.Now())

		fmt.Printf("EndOfDay: %s\n", result)

		require.NotNil(t, result)
	})

	t.Run("BeginningOfMonth", func(t *testing.T) {
		result := helpers.BeginningOfMonth(time.Now())

		fmt.Printf("BeginningOfMonth: %s\n", result)

		require.NotNil(t, result)
	})

	t.Run("EndOfMonth", func(t *testing.T) {
		result := helpers.EndOfMonth(time.Now())

		fmt.Printf("EndOfMonth: %s\n", result)

		require.NotNil(t, result)
	})

	t.Run("BeginningOfYear", func(t *testing.T) {
		result := helpers.BeginningOfYear(time.Now())

		fmt.Printf("BeginningOfYear: %s\n", result)

		require.NotNil(t, result)
	})

	t.Run("EndOfYear", func(t *testing.T) {
		result := helpers.EndOfYear(time.Now())

		fmt.Printf("EndOfYear: %s\n", result)

		require.NotNil(t, result)
	})
}
