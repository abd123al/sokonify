package helpers

import (
	"context"
	"encoding/json"
	"github.com/go-chi/jwtauth"
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

// ForContext finds the user from the context. REQUIRES Middleware to have run.
func ForContext(ctx context.Context) *model.AuthParams {
	_, claims, _ := jwtauth.FromContext(ctx)

	userId := int(claims["userId"].(float64))
	StoreID := int(claims["storeId"].(float64))
	roleStr := claims["role"].(string)

	var Role model.StaffRole

	if len(roleStr) != 0 {
		if roleStr == model.StaffRoleOwner.String() {
			Role = model.StaffRoleOwner
		} else {
			Role = model.StaffRoleStaff
		}
	}

	params := model.AuthParams{
		UserID:  userId,
		StoreID: &StoreID,
		Role:    &Role,
	}

	return &params
}
