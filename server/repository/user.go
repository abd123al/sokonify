package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

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
	var store *model.User
	result := db.Where(&model.User{ID: ID}).First(&store)
	return store, result.Error
}
