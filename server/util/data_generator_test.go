package util_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/util"
	"testing"
)

func TestGenerator(t *testing.T) {
	DB := util.InitDB(util.InitDbArgs{
		DbName:  "mahesabu_test",
		Clear:   true,
		Offline: false,
	})
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, user.ID)
	category := util.CreateCategory(DB, store.ID)
	product := util.CreateProduct(DB, category.ID)

	t.Run("CreateUser", func(t *testing.T) {
		result := util.CreateUser(DB)
		require.Greater(t, result.ID, 0)
	})

	t.Run("CreateStore", func(t *testing.T) {
		result := util.CreateStore(DB, user.ID)
		require.Greater(t, result.ID, 0)
	})

	t.Run("CreateCategory", func(t *testing.T) {
		result := util.CreateCategory(DB, store.ID)
		require.Greater(t, result.ID, 0)
	})

	t.Run("CreateProduct", func(t *testing.T) {
		result := util.CreateProduct(DB, category.ID)
		require.Greater(t, result.ID, 0)
	})

	t.Run("CreateItem", func(t *testing.T) {
		result := util.CreateItem(DB, util.CreateItemArgs{
			ProductID: product.ID,
		})
		require.Greater(t, result.ID, 0)
	})

	t.Run("CreateStaff", func(t *testing.T) {
		result := util.CreateStaff(DB, util.CreateStaffArgs{
			UserID:  user.ID,
			StoreID: store.ID,
		})
		require.Greater(t, result.ID, 0)
	})
}
