package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestProduct(t *testing.T) {
	DB := util.InitTestDB()
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)

	t.Run("CreateProduct", func(t *testing.T) {
		item, _ := repository.CreateProduct(DB, model.ProductInput{
			Name:        "Some store",
			Brands:      nil,
			Description: nil,
		}, helpers.UserAndStoreArgs{
			UserID:  user.ID,
			StoreID: store.ID,
		})

		require.GreaterOrEqual(t, item.ID, 1)
	})

	t.Run("EditProduct", func(t *testing.T) {
		p := util.CreateProduct(DB, nil)
		desc := "New"

		result, err := repository.EditProduct(DB, p.ID, model.ProductInput{
			Name:        "Some store",
			Description: &desc,
		}, helpers.UserAndStoreArgs{
			UserID:  user.ID,
			StoreID: *p.StoreID,
		})

		require.Nil(t, err)
		require.Equal(t, result.ID, p.ID)
		require.Equal(t, result.Description, &desc)
	})
}
