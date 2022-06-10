package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateStaff(db *gorm.DB, input model.StaffInput, args helpers.UserAndStoreArgs) (*model.Staff, error) {
	var hasDefault bool

	memberships, err := FindMyMemberships(db, input.UserID)

	if err != nil {
		return nil, err
	}

	for _, s := range memberships {
		//Checking is user is already a member of this store
		//This will prevent duplicates
		if s.StoreID == args.StoreID {
			return nil, errors.New("user is already a staff in this store")
		}
		//Checking if user has default login store
		if s.Default {
			hasDefault = true
			break
		}
	}

	staff := model.Staff{
		UserID:    input.UserID, //This is user who is about to get membership
		StoreID:   args.StoreID,
		Role:      input.Role,
		Default:   !hasDefault,
		CreatorID: &args.UserID,
	}

	if err := db.Create(&staff).Error; err != nil {
		return nil, err
	}
	return &staff, nil
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

// FindDefaultStoreAndRole When users log in we assign them to their preferred default store
// This is used in generating token only
func FindDefaultStoreAndRole(db *gorm.DB, UserID int) (*helpers.FindDefaultStoreAndRoleResult, error) {
	var roleResult *helpers.FindDefaultStoreAndRoleResult
	if err := db.Model(&model.Staff{}).Where(&model.Staff{UserID: UserID, Default: true}).First(&roleResult).Error; err != nil {
		return nil, err
	}

	return roleResult, nil
}

// FindStoreAndRole When users switch to other store
// This is also used in generating token only
func FindStoreAndRole(db *gorm.DB, Args helpers.UserAndStoreArgs) (*helpers.FindDefaultStoreAndRoleResult, error) {
	var roleResult *helpers.FindDefaultStoreAndRoleResult
	if err := db.Model(&model.Staff{}).Where(&model.Staff{UserID: Args.UserID, StoreID: Args.StoreID}).First(&roleResult).Error; err != nil {
		return nil, err
	}

	return roleResult, nil
}

func FindDefaultStore(db *gorm.DB, UserID int) (*model.Store, error) {
	var store *model.Store
	if err := db.Table("stores").Joins("inner join staffs on staffs.store_id = stores.id AND staffs.user_id = ? AND staffs.default = ?", UserID, true).First(&store).Error; err != nil {
		//We don't want error here. We just need null
		return nil, nil
	}
	return store, nil
}
