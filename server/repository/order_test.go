package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
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
			Type: model.OrderTypeSale,
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
			Type: model.OrderTypePurchase,
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

	t.Run("FindOrders by offset and limit", func(t *testing.T) {
		offset := 0
		limit := 10

		orderResult := util.CreateOrder(DB, nil)

		orders, err := repository.FindOrders(DB, model.OrdersArgs{
			Mode:   model.FetchModePagination,
			By:     model.OrdersByStore,
			Offset: &offset,
			Limit:  &limit,
			Type:   orderResult.Order.Type,
		}, orderResult.IssuerID)

		require.Nil(t, err)
		require.NotEmpty(t, orders)
		require.NotEqual(t, orders[0].ID, 0)
	})

	t.Run("FindOrderCustomerName", func(t *testing.T) {
		orderResult := util.CreateOrder(DB, nil)
		name, err := repository.FindOrderCustomerName(DB, orderResult.Order.ID)

		require.Nil(t, err)
		require.NotEmpty(t, name)
	})

	t.Run("EditOrder", func(t *testing.T) {
		item2 := util.CreateItem(DB, nil, &store.ID)

		orderResult := util.CreateOrder(DB, nil)
		name, err := repository.EditOrder(DB, orderResult.Order.ID, model.OrderInput{
			Type: model.OrderTypeSale,
			Items: []*model.OrderItemInput{
				{
					Quantity: item.Quantity - 1,
					Price:    item.SellingPrice,
					ItemID:   item.ID,
				},
				{
					Quantity: item2.Quantity - 1,
					Price:    item2.SellingPrice,
					ItemID:   item2.ID,
				},
			},
		}, helpers.UserAndStoreArgs{
			UserID:  orderResult.StaffId,
			StoreID: orderResult.IssuerID,
		})

		require.Nil(t, err)
		require.NotEmpty(t, name)
	})
}
