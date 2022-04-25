package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateStaff(db *gorm.DB, input model.StaffInput) (*model.Staff, error) {
	staff := model.Staff{
		StoreID: input.StoreID,
		UserID:  input.UserID,
	}
	result := db.Create(&staff)
	return &staff, result.Error
}

func FindStaff(db *gorm.DB, ID int) (*model.Staff, error) {
	var staff *model.Staff
	result := db.Where(&model.Staff{ID: ID}).First(&staff)
	return staff, result.Error
}
