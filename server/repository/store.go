package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateStore(db *gorm.DB, UserID int, input model.StoreInput, NoOfStores int64) (*model.Store, error) {
	create := func() (*model.Store, error) {
		var store = model.Store{
			Description:  input.Description,
			Name:         input.Name,
			Tin:          input.Tin,
			StoreType:    input.StoreType,
			BusinessType: input.BusinessType,
			TemplateType: input.TemplateType,
			UserID:       UserID,
			Terms:        input.Terms,
		}

		if err := db.Transaction(func(tx *gorm.DB) error {
			if err := db.Create(&store).Error; err != nil {
				return err
			}

			var categories []string

			if store.BusinessType == model.BusinessTypeBoth {
				categories = append(categories, "Retail")
				categories = append(categories, "Wholesale")
			} else if store.BusinessType == model.BusinessTypeRetail {
				categories = append(categories, "Retail")
			} else if store.BusinessType == model.BusinessTypeWholesale {
				categories = append(categories, "Wholesale")
			}

			//Create pricing categories
			for _, c := range categories {
				_, err := CreateCategory(tx, model.CategoryInput{
					Name: c,
					Type: model.CategoryTypePricing,
				}, helpers.UserAndStoreArgs{
					UserID:  UserID,
					StoreID: store.ID,
				})

				if err != nil {
					return err
				}
			}

			err2 := AssignOwnerRole(tx, store)

			if err2 != nil {
				return err2
			}

			return nil
		}); err != nil {
			return nil, err
		}

		return &store, nil
	}

	var count int64
	if err := db.Model(&model.Store{}).Count(&count).Error; err != nil {
		return nil, err
	}

	if count >= NoOfStores {
		return nil, errors.New(fmt.Sprintf("current installation only support %d store", NoOfStores))
	} else {
		return create()
	}
}

// AssignOwnerRole This helps to assign store owner a role
func AssignOwnerRole(tx *gorm.DB, store model.Store) error {
	//create admins category
	role, err := CreateCategory(tx, model.CategoryInput{
		Name:            "Owners",
		Type:            model.CategoryTypeRole,
		PermissionTypes: []model.PermissionType{model.PermissionTypeAll},
	}, helpers.UserAndStoreArgs{
		UserID:  store.UserID,
		StoreID: store.ID,
	})

	if err != nil {
		return err
	}

	//Assign role
	_, err = CreateStaff(tx, model.StaffInput{
		UserID: store.UserID,
		RoleID: role.ID,
	}, helpers.UserAndStoreArgs{
		UserID:  store.UserID,
		StoreID: store.ID,
	})

	if err != nil {
		return err
	}

	return nil
}

func EditStore(db *gorm.DB, input model.StoreInput, args helpers.UserAndStoreArgs) (*model.Store, error) {
	var store = model.Store{
		ID:           args.StoreID,
		Description:  input.Description,
		Name:         input.Name,
		Tin:          input.Tin,
		StoreType:    input.StoreType,
		BusinessType: input.BusinessType,
		TemplateType: input.TemplateType,
		Terms:        input.Terms,
	}

	if err := db.Model(&model.Store{}).Where(&model.Store{ID: args.StoreID, UserID: args.UserID}).Updates(&store).Error; err != nil {
		return nil, err
	}

	return &store, nil
}

func FindStores(db *gorm.DB, UserId int) ([]*model.Store, error) {
	var stores []*model.Store
	result := db.Table("stores").Joins("inner join categories on categories.store_id = stores.id").Joins("inner join staffs on staffs.role_id = categories.id AND staffs.user_id = ?", UserId).Find(&stores)
	return stores, result.Error
}

// FindStore This is to be used by admins only
func FindStore(db *gorm.DB, ID int) (*model.Store, error) {
	var store *model.Store
	result := db.Where(&model.Store{ID: ID}).First(&store)
	return store, result.Error
}

// FindStaffStore When user wants to change store we have to make sure that they are member of that store
// This is also used for finding current store.
func FindStaffStore(db *gorm.DB, Args helpers.UserAndStoreArgs) (*model.Store, error) {
	var store *model.Store
	if err := db.Table("stores").Joins("inner join categories on categories.store_id = stores.id AND store_id = ?", Args.StoreID).Joins("inner join staffs on staffs.role_id = categories.id AND staffs.user_id = ?", Args.UserID).First(&store).Error; err != nil {
		return nil, nil //We neglect errors because we just resolve null
	}
	return store, nil
}
