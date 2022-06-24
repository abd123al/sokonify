package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateCustomer(DB *gorm.DB, input model.CustomerInput, StoreID int) (*model.Customer, error) {
	var user *model.User
	email := input.Email
	phone := input.Phone

	//Here we link customers to their user account directly
	if email != nil {
		DB.Where(&model.User{Email: *email}).First(&user)
	} else if phone != nil {
		DB.Where(&model.User{Phone: *phone}).First(&user)
	}

	customer := model.Customer{
		Name:    input.Name,
		StoreID: StoreID,
		Type:    input.Type,
		Gender:  input.Gender,
		Dob:     input.Dob,
		Email:   input.Email,
		Address: input.Address,
		Phone:   input.Phone,
	}

	if user != nil {
		customer.UserID = &user.ID
	}

	result := DB.Create(&customer)
	return &customer, result.Error
}

func EditCustomer(DB *gorm.DB, ID int, input model.CustomerInput, StoreID int) (*model.Customer, error) {
	customer := model.Customer{
		Name:    input.Name,
		Type:    input.Type,
		Gender:  input.Gender,
		Dob:     input.Dob,
		Email:   input.Email,
		Address: input.Address,
		Phone:   input.Phone,
	}

	if err := DB.Model(&model.Customer{}).Where(&model.Customer{ID: ID, StoreID: StoreID}).Updates(&customer).Error; err != nil {
		return nil, err
	}

	return &customer, nil
}

func FindCustomers(DB *gorm.DB, storeID int) ([]*model.Customer, error) {
	var customers []*model.Customer
	result := DB.Where(&model.Customer{StoreID: storeID}).Order("id DESC").Find(&customers)
	return customers, result.Error
}

func FindCustomer(db *gorm.DB, ID int) (*model.Customer, error) {
	var customer *model.Customer
	result := db.Where(&model.Customer{ID: ID}).First(&customer)
	return customer, result.Error
}
