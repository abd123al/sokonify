package repository_test

import (
	"github.com/stretchr/testify/require"
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
		fn := func() (*model.Staff, error) {
			input := model.StaffInput{
				UserID: UserID,
				Role:   model.StaffRoleStaff,
			}
			return repository.CreateStaff(DB, input, StoreID)
		}

		staff, err := fn()

		require.Nil(t, err)
		require.NotNil(t, staff)

		//We shouldn't allow duplicates
		staff1, err1 := fn()

		require.Nil(t, staff1)
		require.NotNil(t, err1)
	})
}
