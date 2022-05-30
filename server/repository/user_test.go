package repository_test

import (
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestUser(t *testing.T) {
	DB := util.InitTestDB()
	User := util.CreateUser(DB)

	t.Run("SignUp", func(t *testing.T) {
		Username := faker.Username()

		input := model.SignUpInput{
			Name:     faker.Word(),
			Username: &Username,
			Email:    faker.Email(),
			Password: faker.Password(),
		}

		payload, err := repository.SignUp(DB, input)

		require.NotNil(t, payload.AccessToken)
		require.NotNil(t, payload.User.Password)
		require.Nil(t, err)

		//using same email
		payload2, err2 := repository.SignUp(DB, input)
		require.ErrorContains(t, err2, "email")
		require.Nil(t, payload2)

		//using same username
		input.Email = faker.Email() //changing the current one

		payload3, err3 := repository.SignUp(DB, input)
		require.ErrorContains(t, err3, "username")
		require.Nil(t, payload3)
	})

	t.Run("login with valid email", func(t *testing.T) {
		payload, err := repository.SignIn(DB, model.SignInInput{
			Login:    User.Email,
			Password: "password",
		})

		require.NotNil(t, payload.AccessToken)
		require.NotNil(t, payload.User)
		require.Nil(t, err)
	})

	t.Run("login with valid username", func(t *testing.T) {
		payload, err := repository.SignIn(DB, model.SignInInput{
			Login:    *User.Username,
			Password: "password",
		})

		require.NotNil(t, payload.AccessToken)
		require.NotNil(t, payload.User)
		require.Nil(t, err)
	})

	t.Run("login with invalid login", func(t *testing.T) {
		payload, err := repository.SignIn(DB, model.SignInInput{
			Login:    faker.Email(),
			Password: "password",
		})

		require.NotNil(t, err)
		require.Nil(t, payload)
	})

	t.Run("login with wrong password", func(t *testing.T) {
		payload, err := repository.SignIn(DB, model.SignInInput{
			Login:    User.Email,
			Password: faker.Password(),
		})

		require.NotNil(t, err)
		require.Nil(t, payload)
	})

	t.Run("switch store", func(t *testing.T) {
		staff := util.CreateStaff(DB, nil)

		payload, err := repository.SwitchStore(DB, helpers.UserAndStoreArgs{
			StoreID: staff.StoreID,
			UserID:  staff.UserID,
		})

		require.NotNil(t, payload.AccessToken)
		require.Nil(t, payload.User)
		require.Nil(t, err)
	})

	t.Run("switch to unemployed store", func(t *testing.T) {
		store := util.CreateStore(DB, nil)

		args := helpers.UserAndStoreArgs{
			StoreID: store.ID,
			UserID:  User.ID,
		}

		payload, err := repository.SwitchStore(DB, args)

		require.Nil(t, payload)
		require.NotNil(t, err)
	})

	t.Run("FindName", func(t *testing.T) {
		staff := util.CreateStaff(DB, nil)

		name, err := repository.FindName(DB, staff.UserID)

		require.Nil(t, err)
		require.NotEmpty(t, name)
	})
}
