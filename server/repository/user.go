package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

// SignUp todo add listener for lowercase username and email
func SignUp(db *gorm.DB, input model.SignUpInput) (*model.AuthPayload, error) {
	var first *model.User
	if rows := db.Where(&model.User{Email: input.Email}).Find(&first).RowsAffected; rows > 0 {
		return nil, errors.New("account with similar email already exists")
	}

	if input.Username != nil {
		if rows := db.Where(&model.User{Username: input.Username}).Find(&first).RowsAffected; rows > 0 {
			return nil, errors.New("account with similar username already exists")
		}
	}

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
		AccessToken: helpers.GenerateAuthToken(user.ID, nil),
		User:        &user,
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
			args, _ := FindDefaultStoreAndRole(db, user.ID)
			payload = &model.AuthPayload{
				AccessToken: helpers.GenerateAuthToken(user.ID, args),
				User:        user,
			}

			return payload, nil
		}
	}

	return nil, err
}

func ChangePassword(db *gorm.DB, ID int, input model.ChangePasswordInput) (bool, error) {
	var user *model.User
	var err = errors.New("incorrect password")

	if input.NewPassword == input.CurrentPassword {
		return false, errors.New("new password should be different from old one")
	}

	result := db.Where(&model.User{ID: ID}).Find(&user)

	if result.RowsAffected == 0 {
		return false, err
	} else if user.Password != nil {
		if helpers.VerifyPassword(input.CurrentPassword, *user.Password) {
			hash := helpers.HashPassword(input.NewPassword)

			update := model.User{
				ID:       ID,
				Password: &hash,
			}

			if err := db.Model(&model.User{}).Where(&model.User{ID: ID}).Updates(&update).Error; err != nil {
				return false, err
			}

			return true, nil
		}
	}

	return false, err
}

// EditProfile todo check email and username
func EditProfile(db *gorm.DB, ID int, input model.ProfileInput) (*model.User, error) {
	user := model.User{
		ID:       ID,
		Name:     input.Name,
		Email:    input.Email,
		Username: input.Username,
		Phone:    input.Phone,
	}

	if err := db.Model(&user).Where(&model.User{ID: ID}).Updates(&user).Error; err != nil {
		return nil, err
	}

	return &user, nil
}

func SwitchStore(db *gorm.DB, args helpers.UserAndStoreArgs) (*model.AuthPayload, error) {
	var payload *model.AuthPayload
	var err = errors.New("switch to other store failed")

	result, e := FindStoreAndRole(db, args)
	if e != nil {
		return nil, err
	}

	payload = &model.AuthPayload{
		AccessToken: helpers.GenerateAuthToken(args.UserID, result),
		//todo if nill resolve
	}

	return payload, nil
}

func FindUser(db *gorm.DB, ID int) (*model.User, error) {
	var user *model.User
	result := db.Where(&model.User{ID: ID}).First(&user)
	return user, result.Error
}

// FindUsers todo
func FindUsers(db *gorm.DB, args model.UsersArgs) ([]*model.User, error) {
	var users []*model.User
	result := db.Find(&users)
	return users, result.Error
}

func FindName(db *gorm.DB, UserID int) (string, error) {
	var name string

	err := db.Model(&model.User{}).Where(&model.User{ID: UserID}).Select("name").Row().Scan(&name)
	if err != nil {
		return "", nil
	}

	return name, nil
}
