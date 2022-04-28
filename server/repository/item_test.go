package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestItem(t *testing.T) {
	DB := util.InitTestDB()
	product := util.CreateProduct(DB, nil)

	t.Run("CreateItem", func(t *testing.T) {
		item, _ := repository.CreateItem(DB, model.ItemInput{
			ProductID: product.ID,
		})

		require.GreaterOrEqual(t, item.ID, 1)
	})

	var create = func() {
		_, _ = repository.CreateItem(DB, model.ItemInput{
			Quantity:     12,
			BuyingPrice:  "2000",
			SellingPrice: "5000",
			ProductID:    product.ID,
		})
	}

	t.Run("FindItems by store", func(t *testing.T) {
		create()

		items, _ := repository.FindItems(DB, model.ItemsArgs{
			By:    model.ItemsByStore,
			Value: *product.StoreID,
		})

		require.NotEmpty(t, items)
	})

	t.Run("FindItems by product", func(t *testing.T) {
		create()

		items, _ := repository.FindItems(DB, model.ItemsArgs{
			By:    model.ItemsByProduct,
			Value: product.ID,
		})

		require.NotEmpty(t, items)
	})
}
