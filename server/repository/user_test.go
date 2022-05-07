package repository_test

import (
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestUser(t *testing.T) {
	DB := util.InitTestDB()

	t.Run("CreateUser", func(t *testing.T) {
		Username := faker.Username()

		user, _ := repository.CreateUser(DB, model.SignUpInput{
			Name:     faker.Word(),
			Username: &Username,
			Email:    faker.Email(),
			Password: faker.Password(),
		})

		require.NotNil(t, user.Password)
	})
}
