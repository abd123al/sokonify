package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestOrders(t *testing.T) {
	DB := util.InitTestDB()
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)
	item := util.CreateItem(DB, nil, &store.ID)

	t.Run("CreateOrder with sufficient quantity", func(t *testing.T) {
		order, err := repository.CreateOrder(DB, user.ID, model.OrderInput{
			Type:     model.OrderTypeIn,
			IssuerID: store.ID,
			Items: []*model.OrderItemInput{
				{
					Quantity: item.Quantity,
					Price:    item.SellingPrice,
					ItemID:   item.ID,
				},
			},
		}, store.ID)

		require.Nil(t, err)
		require.NotNil(t, order)
	})

	t.Run("CreateOrder with insufficient quantity", func(t *testing.T) {
		order, err := repository.CreateOrder(DB, user.ID, model.OrderInput{
			Type:     model.OrderTypeIn,
			IssuerID: store.ID,
			Items: []*model.OrderItemInput{
				{
					Quantity: item.Quantity + 1,
					Price:    item.SellingPrice,
					ItemID:   item.ID,
				},
			},
		}, store.ID)

		require.Nil(t, order)
		require.NotNil(t, err)
	})

	t.Run("FindOrders by timeframe", func(t *testing.T) {
		timeframe := model.TimeframeTypeToday

		orderResult := util.CreateOrder(DB, nil)

		orders, err := repository.FindOrders(DB, model.OrdersArgs{
			Mode:      model.FetchModeFull,
			By:        model.OrdersByStore,
			Timeframe: &timeframe,
			Type:      orderResult.Order.Type,
		}, orderResult.IssuerID)

		require.Nil(t, err)
		require.NotEmpty(t, orders)
		require.NotEqual(t, orders[0].ID, 0)
	})
}
