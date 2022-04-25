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
