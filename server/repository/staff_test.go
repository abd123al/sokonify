package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
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
			return repository.CreateStaff(DB, input, helpers.UserAndStoreArgs{
				UserID:  UserID,
				StoreID: StoreID,
			})
		}

		staff, err := fn()

		require.Nil(t, err)
		require.NotNil(t, staff)

		//We shouldn't allow duplicates
		staff1, err1 := fn()

		require.Nil(t, staff1)
		require.NotNil(t, err1)
	})

	t.Run("FindDefaultStoreAndRole", func(t *testing.T) {
		UserID := util.CreateUser(DB).ID

		staff := util.CreateStaff(DB, &util.CreateStaffArgs{
			UserID:  UserID,
			StoreID: StoreID,
		})

		result, err := repository.FindDefaultStoreAndRole(DB, UserID)

		require.Nil(t, err)
		require.Equal(t, staff.StoreID, result.StoreID)
		require.Equal(t, staff.Default, true)
	})

	t.Run("FindDefaultStoreAndRole with no store", func(t *testing.T) {
		UserID := util.CreateUser(DB).ID

		result, err := repository.FindDefaultStoreAndRole(DB, UserID)

		require.NotNil(t, err)
		require.Nil(t, result)
	})

	t.Run("FindStoreAndRole", func(t *testing.T) {
		UserID := util.CreateUser(DB).ID

		staff := util.CreateStaff(DB, &util.CreateStaffArgs{
			UserID:  UserID,
			StoreID: StoreID,
		})

		result, err := repository.FindStoreAndRole(DB, helpers.UserAndStoreArgs{
			UserID:  UserID,
			StoreID: StoreID,
		})

		require.Nil(t, err)
		require.Equal(t, staff.StoreID, result.StoreID)
	})

	t.Run("FindStoreAndRole with non staff", func(t *testing.T) {
		storeId := util.CreateStore(DB, nil).ID //user is not staff here

		result, err := repository.FindStoreAndRole(DB, helpers.UserAndStoreArgs{
			UserID:  UserID,
			StoreID: storeId,
		})

		require.NotNil(t, err)
		require.Nil(t, result)
	})

	t.Run("FindDefaultStore with default store", func(t *testing.T) {
		UserID := util.CreateUser(DB).ID

		staff := util.CreateStaff(DB, &util.CreateStaffArgs{
			UserID:  UserID,
			StoreID: StoreID,
		})

		result, err := repository.FindDefaultStore(DB, UserID)

		require.Nil(t, err)
		require.Equal(t, staff.StoreID, result.ID)
		require.Equal(t, staff.Default, true)
	})

	t.Run("FindDefaultStore with no store", func(t *testing.T) {
		UserID := util.CreateUser(DB).ID

		result, err := repository.FindDefaultStore(DB, UserID)

		require.Nil(t, err)
		require.Nil(t, result)
	})
}
