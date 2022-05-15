package repository_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestItem(t *testing.T) {
	DB := util.InitTestDB()
	product := util.CreateProduct(DB, nil)
	unit := util.CreateUnit(DB, product.StoreID, nil)

	t.Run("CreateItem", func(t *testing.T) {
		item, _ := repository.CreateItem(DB, model.ItemInput{
			ProductID:    product.ID,
			UnitID:       unit.ID,
			Quantity:     12,
			BuyingPrice:  "2000",
			SellingPrice: "5000",
		})

		require.GreaterOrEqual(t, item.ID, 1)
	})

	var create = func() {
		_, _ = repository.CreateItem(DB, model.ItemInput{
			Quantity:     12,
			BuyingPrice:  "2000",
			UnitID:       unit.ID,
			SellingPrice: "5000",
			ProductID:    product.ID,
		})
	}

	t.Run("FindItems by store", func(t *testing.T) {
		create()

		items, err := repository.FindItems(DB, model.ItemsArgs{
			By: model.ItemsByStore,
		}, *product.StoreID)

		for i := 0; i < len(items); i++ {
			fmt.Println(items[i].ID)
		}

		require.Nil(t, err)
		require.NotEmpty(t, items)
	})

	t.Run("FindItems by product", func(t *testing.T) {
		create()

		items, _ := repository.FindItems(DB, model.ItemsArgs{
			By:    model.ItemsByProduct,
			Value: product.ID,
		}, *product.StoreID)

		require.NotEmpty(t, items)
	})
}
