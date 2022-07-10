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
		RoleID:    input.RoleID,
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
	result := db.Table("staffs").Joins("inner join categories on categories.id = staffs.role_id AND categories.store_id = ?", StoreID).Find(&staffs)
	return staffs, result.Error
}

type FindMembershipResult struct {
	StoreID int
	Default bool
}

// FindMyMemberships This will get all stores id in which this user is a member
// Very useful for checking where user has access
func FindMyMemberships(db *gorm.DB, UserID int) ([]*FindMembershipResult, error) {
	var r []*FindMembershipResult
	result := db.Table("staffs").Joins("inner join categories ON categories.id = staffs.role_id").Where(&model.Staff{UserID: UserID}).Select("categories.store_id AS store_id,staffs.default AS default").Scan(&r)
	return r, result.Error
}

// FindDefaultStoreAndRole When users log in we assign them to their preferred default store
// This is used in generating token only
func FindDefaultStoreAndRole(db *gorm.DB, UserID int) (*helpers.FindDefaultStoreAndRoleResult, error) {
	var roleResult *helpers.FindDefaultStoreAndRoleResult
	result := db.Table("staffs").Joins("inner join categories on staffs.role_id = categories.id").Where(&model.Staff{UserID: UserID, Default: true}).Select("categories.store_id AS store_id").Scan(&roleResult)

	if result.Error != nil {
		return nil, result.Error
	}

	if result.RowsAffected == 0 {
		return nil, errors.New("no store found")
	}

	return roleResult, nil
}

// FindStoreAndRole When users switch to other store
// This is also used in generating token only
func FindStoreAndRole(db *gorm.DB, Args helpers.UserAndStoreArgs) (*helpers.FindDefaultStoreAndRoleResult, error) {
	var roleResult *helpers.FindDefaultStoreAndRoleResult
	result := db.Table("staffs").Joins("inner join categories on staffs.role_id = categories.id AND categories.store_id = ? AND staffs.user_id = ?", Args.StoreID, Args.UserID).Select("categories.store_id as store_id").Scan(&roleResult)

	if result.Error != nil {
		return nil, result.Error
	}

	if result.RowsAffected == 0 {
		return nil, errors.New("no record found")
	}

	return roleResult, nil
}

func FindDefaultStore(db *gorm.DB, UserID int) (*model.Store, error) {
	var store *model.Store
	if err := db.Table("stores").Joins("inner join categories ON categories.store_id = stores.id").Joins("inner join staffs on staffs.role_id = categories.id AND staffs.user_id = ? AND staffs.default = ?", UserID, true).First(&store).Error; err != nil {
		return nil, nil
	}
	return store, nil
}
