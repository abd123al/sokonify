package helpers

import (
	"encoding/json"
	"mahesabu/graph/model"
)

func GenerateAuthToken(user model.User) string {
	var myMap map[string]interface{}

	StoreId := 2
	role := model.StaffRoleStaff

	// AuthParams A stand-in for our database backed user object
	// todo inject this to every resolver.
	payload := model.AuthParams{
		UserID:  user.ID,
		StoreID: &StoreId,
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
