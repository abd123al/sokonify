package repository_test

import (
	"github.com/stretchr/testify/assert"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestStaff(t *testing.T) {
	DB := util.InitTestDB()
	UserID := util.CreateUser(DB).ID
	StoreID := util.CreateStore(DB, nil).ID

	t.Run("CreateStaff", func(t *testing.T) {
		staff, err := repository.CreateStaff(DB, model.StaffInput{
			UserID: UserID,
			Role:   model.StaffRoleStaff,
		}, StoreID)

		assert.Nil(t, err)
		assert.NotNil(t, staff)
	})
}
