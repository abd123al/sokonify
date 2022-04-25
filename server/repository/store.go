package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateStore(db *gorm.DB, UserId int, input model.StoreInput) (*model.Store, error) {
	//todo use transaction and save user as staff.
	store := model.Store{
		Name:    input.Name,
		OwnerID: UserId,
	}
	result := db.Create(&store)
	return &store, result.Error
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
