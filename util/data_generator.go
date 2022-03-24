package util

import (
	"github.com/bxcodec/faker/v3"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

// CreateUser Upper case means function is exported
func CreateUser(DB *gorm.DB) *model.User {
	user := model.User{}

	_ = faker.FakeData(&user)

	DB.Create(&user)

	return &user
}
