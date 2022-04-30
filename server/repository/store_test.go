package repository_test

import (
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestStore(t *testing.T) {
	DB := util.InitTestDB()
	UserID := util.CreateUser(DB).ID

	t.Run("CreateStore", func(t *testing.T) {
		staff, err := repository.CreateStore(DB, UserID, model.StoreInput{
			Name: faker.Name(),
		})

		assert.Nil(t, err)
		assert.NotNil(t, staff)
	})
}
