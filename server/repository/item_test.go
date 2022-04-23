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
	product := util.CreateProduct(DB, util.CreateProductArgs{})

	t.Run("CreateItem", func(t *testing.T) {
		item, _ := repository.CreateItem(DB, model.ItemInput{
			ProductID: product.ID,
		})

		require.GreaterOrEqual(t, item.ID, 1)
	})
}
