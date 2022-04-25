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
