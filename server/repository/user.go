package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

// CreateUser todo add listener for lowercase username and email
func CreateUser(db *gorm.DB, input model.SignUpInput) (*model.User, error) {
	password := helpers.HashPassword(input.Password)

	user := model.User{
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Password: &password,
	}

	result := db.Create(&user)
	return &user, result.Error
}

func FindUser(db *gorm.DB, ID int) (*model.User, error) {
	var user *model.User
	result := db.Where(&model.User{ID: ID}).First(&user)
	return user, result.Error
}

func Login(db *gorm.DB, input model.SignInInput) (*model.User, error) {
	var user *model.User
	var err = errors.New("incorrect username or password")

	result := db.Where(db.Where(&model.User{Email: input.Login}).Or(&model.User{Username: &input.Login})).Find(&user)

	if result.RowsAffected == 0 {
		return nil, err
	} else if user.Password != nil {
		if helpers.VerifyPassword(input.Password, *user.Password) {
			return user, nil
		}
	}

	return nil, err
}
