package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateStaff(db *gorm.DB, input model.StaffInput, StoreID int) (*model.Staff, error) {
	staff := model.Staff{
		UserID:  input.UserID,
		StoreID: StoreID,
		Role:    input.Role,
	}
	result := db.Create(&staff)
	return &staff, result.Error
}

func FindStaff(db *gorm.DB, ID int) (*model.Staff, error) {
	var staff *model.Staff
	result := db.Where(&model.Staff{ID: ID}).First(&staff)
	return staff, result.Error
}

func FindStaffs(db *gorm.DB, StoreID int) ([]*model.Staff, error) {
	var staffs []*model.Staff
	result := db.Where(&model.Staff{StoreID: StoreID}).Find(&staffs)
	return staffs, result.Error
}
