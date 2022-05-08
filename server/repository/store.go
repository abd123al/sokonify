package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateStore(db *gorm.DB, UserID int, input model.StoreInput) (*model.Store, error) {
	var store = model.Store{
		Address:     input.Address,
		Description: input.Description,
		Email:       input.Email,
		Name:        input.Name,
		Tin:         input.Tin,
		Type:        input.Type,
		UserID:      UserID,
	}

	err := db.Transaction(func(tx *gorm.DB) error {
		if err := db.Create(&store).Error; err != nil {
			return err
		}

		_, err := CreateStaff(tx, model.StaffInput{
			UserID: UserID,
			Role:   model.StaffRoleOwner,
		}, store.ID)

		if err != nil {
			return err
		}

		return nil
	})

	return &store, err
}

func FindStores(db *gorm.DB, UserId int) ([]*model.Store, error) {
	var stores []*model.Store
	result := db.Table("stores").Joins("inner join staffs on staffs.store_id = stores.id AND staffs.user_id = ?", UserId).Find(&stores)
	return stores, result.Error
}

func FindStore(db *gorm.DB, ID int) (*model.Store, error) {
	var store *model.Store
	result := db.Where(&model.Store{ID: ID}).First(&store)
	return store, result.Error
}
