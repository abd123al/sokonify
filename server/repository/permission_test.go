package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestPermission(t *testing.T) {
	DB := util.InitTestDB()
	UserID := util.CreateUser(DB).ID
	Store := util.CreateStore(DB, nil)
	StoreID := Store.ID
	RoleID := util.CreateCategory(DB, StoreID, model.CategoryTypeRole).ID

	t.Run("SetPermissions", func(t *testing.T) {
		fn := func() ([]*model.Permission, error) {
			p1 := model.PermissionTypeCreateBrand
			p2 := model.PermissionTypeAddStock

			PricingID := util.CreateCategory(DB, StoreID, model.CategoryTypePricing).ID

			input := model.PermissionsInput{
				Permissions: []*model.PermissionType{
					&p1, &p2,
				},
				PricingIds: []*int{
					&PricingID,
				},
				RoleID: RoleID,
			}

			return repository.SetPermissions(DB, input, helpers.UserAndStoreArgs{
				UserID:  UserID,
				StoreID: StoreID,
			})
		}

		staff, err := fn()

		require.Nil(t, err)
		require.NotNil(t, staff)
	})
}
