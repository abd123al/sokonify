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
}
