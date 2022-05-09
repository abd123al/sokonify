package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateStaff(db *gorm.DB, input model.StaffInput, StoreID int) (*model.Staff, error) {
	var hasDefault bool

	memberships, err := FindMyMemberships(db, input.UserID)

	if err != nil {
		return nil, err
	}

	for _, s := range memberships {
		//Checking is user is already a member of this store
		//This will prevent duplicates
		if s.ID == StoreID {
			return nil, errors.New("user is already a staff in this store")
		}
		//Checking if user has default login store
		if s.Default {
			hasDefault = true
			break
		}
	}

	staff := model.Staff{
		UserID:  input.UserID, //This is user who is about to get membership
		StoreID: StoreID,
		Role:    input.Role,
		Default: !hasDefault,
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

// FindMyMemberships This will get all stores id in which this user is a member
// Very useful for checking where user has access
func FindMyMemberships(db *gorm.DB, UserID int) ([]*model.Staff, error) {
	var staffs []*model.Staff
	result := db.Where(&model.Staff{UserID: UserID}).Find(&staffs)
	return staffs, result.Error
}
