package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestPrice(t *testing.T) {
	DB := util.InitTestDB()
	Store := util.CreateStore(DB, nil)
	CategoryID := util.CreateCategory(DB, Store.ID, model.CategoryTypePricing).ID
	Amount := "10000"

	insert := func(ItemID int) *model.Price {
		result, err := repository.CreatePrice(DB, ItemID, model.PriceInput{
			Amount:     Amount,
			CategoryID: CategoryID,
		}, helpers.UserAndStoreArgs{
			UserID:  Store.UserID,
			StoreID: Store.ID,
		})

		require.Nil(t, err)

		return result
	}

	t.Run("CreatePrice", func(t *testing.T) {
		ar := util.CreateItemArgs{
			StoreID: Store.ID,
		}

		ItemID1 := util.CreateItem(DB, ar).ID
		ItemID2 := util.CreateItem(DB, ar).ID

		require.NotEqual(t, ItemID1, ItemID2)

		res1 := insert(ItemID1)
		res2 := insert(ItemID2)

		require.Equal(t, Amount, res1.Amount)
		require.Equal(t, Amount, res2.Amount)

		require.NotEqual(t, res2.ID, res1.ID)
	})
}
