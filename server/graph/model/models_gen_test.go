package model_test

import (
	"fmt"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"mahesabu/graph/model"
	"testing"
)

func TestModels(t *testing.T) {
	t.Run("fake user model", func(t *testing.T) {
		a := model.User{}
		err := faker.FakeData(&a)
		if err != nil {
			fmt.Println(err)
		}
		//fmt.Printf("%+v", a)

		assert.Equal(t, a.Name, a.Name)
	})

	t.Run("fake ", func(t *testing.T) {
		assert.Equal(t, 1, 1)
	})
}
