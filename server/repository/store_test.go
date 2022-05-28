package repository_test

import (
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestStore(t *testing.T) {
	DB := util.InitTestDB()
	UserID := util.CreateUser(DB).ID

	t.Run("CreateStore", func(t *testing.T) {
		store, err := repository.CreateStore(DB, UserID, model.StoreInput{
			Name: faker.Name(),
		}, false)

		assert.Nil(t, err)
		assert.NotNil(t, store)
	})

	t.Run("should fail to CreateStore when there is one", func(t *testing.T) {
		util.CreateStore(DB, nil)

		store, err := repository.CreateStore(DB, UserID, model.StoreInput{
			Name: faker.Name(),
		}, false)

		assert.NotNil(t, err)
		assert.Nil(t, store)
	})

	t.Run("FindStaffStore with valid store", func(t *testing.T) {
		store := util.CreateStore(DB, &UserID)

		result, err := repository.FindStaffStore(DB, helpers.UserAndStoreArgs{
			UserID:  store.UserID,
			StoreID: store.ID,
		})

		assert.Nil(t, err)
		assert.NotNil(t, result)
	})

	t.Run("FindStaffStore with invalid store", func(t *testing.T) {
		store := util.CreateStore(DB, nil) //user will not be employed

		result, err := repository.FindStaffStore(DB, helpers.UserAndStoreArgs{
			UserID:  UserID,
			StoreID: store.ID, //not a member
		})

		assert.Nil(t, err)
		assert.Nil(t, result)
	})

	t.Run("FindStaffStore with invalid values", func(t *testing.T) {
		result, err := repository.FindStaffStore(DB, helpers.UserAndStoreArgs{
			UserID:  100,
			StoreID: 200,
		})

		assert.Nil(t, err)
		assert.Nil(t, result)
	})
}
