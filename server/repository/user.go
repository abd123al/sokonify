package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

// SignUp todo add listener for lowercase username and email
func SignUp(db *gorm.DB, input model.SignUpInput) (*model.AuthPayload, error) {
	var payload *model.AuthPayload
	password := helpers.HashPassword(input.Password)

	user := model.User{
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Password: &password,
	}

	result := db.Create(&user)

	payload = &model.AuthPayload{
		//AccessToken: util.GenerateAuthToken(user),
		User:  &user,
		Store: nil,
	}

	return payload, result.Error
}

func SignIn(db *gorm.DB, input model.SignInInput) (*model.AuthPayload, error) {
	var payload *model.AuthPayload
	var user *model.User
	var err = errors.New("incorrect username or password")

	result := db.Where(db.Where(&model.User{Email: input.Login}).Or(&model.User{Username: &input.Login})).Find(&user)

	if result.RowsAffected == 0 {
		return nil, err
	} else if user.Password != nil {
		if helpers.VerifyPassword(input.Password, *user.Password) {
			//payload.AccessToken = util.GenerateAuthToken(*user)
			payload = &model.AuthPayload{
				AccessToken: "",
				User:        user,
			}
			return payload, nil
		}
	}

	return nil, err
}

func FindUser(db *gorm.DB, ID int) (*model.User, error) {
	var user *model.User
	result := db.Where(&model.User{ID: ID}).First(&user)
	return user, result.Error
}
