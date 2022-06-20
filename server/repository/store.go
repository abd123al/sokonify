package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateStore(db *gorm.DB, UserID int, input model.StoreInput, Multistore bool) (*model.Store, error) {
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

			role, er := CreateRole(db, model.RoleInput{
				Name: "Admins",
			}, helpers.UserAndStoreArgs{
				UserID:  UserID,
				StoreID: store.ID,
			})

			if er != nil {
				return er
			}

			_, err := CreateStaff(tx, model.StaffInput{
				UserID: UserID,
				RoleID: role.ID,
			}, helpers.UserAndStoreArgs{
				UserID:  UserID,
				StoreID: store.ID,
			})

			if err != nil {
				return err
			}

			return nil
		}); err != nil {
			return nil, err
		}

		return &store, nil
	}

	if Multistore {
		return create()
	} else {
		var count int64
		if err := db.Model(&model.Store{}).Count(&count).Error; err != nil {
			return nil, err
		}

		if count >= 1 {
			return nil, errors.New("multi-stores are not allowed in this current installation")
		} else {
			return create()
		}
	}
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
	result := db.Table("stores").Joins("inner join staffs on staffs.store_id = stores.id AND staffs.user_id = ?", UserId).Find(&stores)
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
	if err := db.Table("stores").Joins("inner join staffs on staffs.store_id = stores.id AND staffs.user_id = ? AND staffs.store_id = ?", Args.UserID, Args.StoreID).First(&store).Error; err != nil {
		return nil, nil //We neglect errors because we just resolve null
	}
	return store, nil
}
