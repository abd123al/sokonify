package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestOrderItems(t *testing.T) {
	DB := util.InitTestDB()

	t.Run("FindOrderItems", func(t *testing.T) {
		orderResult := util.CreateOrder(DB, nil)

		orders, err := repository.FindOrderItems(DB, orderResult.Order.ID)

		require.Nil(t, err)
		require.NotEmpty(t, orders)
		require.NotEqual(t, orders[0].ID, 0)
	})
}
