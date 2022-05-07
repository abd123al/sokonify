package util

import (
	"encoding/json"
	"github.com/go-chi/jwtauth"
	"mahesabu/graph/model"
)

var TokenAuth = jwtauth.New("HS256", []byte("secret"), nil)

func GenerateAuthToken(user model.User) string {
	var myMap map[string]interface{}

	StoreId := 2
	role := model.StaffRoleStaff

	payload := AuthParams{
		UserId:  user.ID,
		StoreId: &StoreId,
		Role:    &role,
	}

	data, _ := json.Marshal(payload)
	err := json.Unmarshal(data, &myMap)

	if err != nil {
		panic(err)
	}

	_, tokenString, _ := TokenAuth.Encode(myMap)

	return tokenString
}
