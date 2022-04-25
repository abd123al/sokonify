package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateUser(db *gorm.DB, input model.UserInput) (*model.User, error) {
	user := model.User{
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Password: input.Password,
	}
	result := db.Create(&user)
	return &user, result.Error
}
