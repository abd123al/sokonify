package helpers

import (
	"context"
	"encoding/json"
	"github.com/go-chi/jwtauth"
	"mahesabu/graph/model"
)

type FindDefaultStoreAndRoleResult struct {
	StoreID int
	RoleID  int
	//todo this should not be here. We should find permission based on roleId this will make it easier to revoke..
	Permissions []*model.Permission `json:"permissions" gorm:"-"`
}

func GenerateAuthToken(UserID int, args *FindDefaultStoreAndRoleResult) string {
	var myMap map[string]interface{}
	//This is used to allow access to operations
	var permissions []string
	//This is used to allow selling items according to some kind of pricing.
	var prices []int

	payload := model.AuthParams{
		UserID: UserID,
	}

	if args != nil {
		payload.StoreID = args.StoreID
		payload.RoleID = args.RoleID

		if args.Permissions != nil {
			for _, p := range args.Permissions {
				if p.Permission != nil {
					str := p.Permission.String()
					permissions = append(permissions, str)
				}

				if p.PricingID != nil {
					prices = append(prices, *p.PricingID)
				}
			}

			payload.Permissions = permissions
			payload.Prices = prices
		}
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

	return ExtractAuthParams(claims)
}

func ExtractAuthParams(claims map[string]interface{}) *model.AuthParams {
	var permissions []string
	var prices []int

	userId := int(claims["userId"].(float64))
	StoreID := int(claims["storeId"].(float64))
	RoleID := int(claims["roleId"].(float64))
	for _, s := range claims["permissions"].([]interface{}) {
		permissions = append(permissions, s.(string))
	}
	for _, s := range claims["prices"].([]interface{}) {
		prices = append(prices, int(s.(float64)))
	}

	params := model.AuthParams{
		UserID:      userId,
		StoreID:     StoreID,
		RoleID:      RoleID,
		Permissions: permissions,
		Prices:      prices,
	}

	return &params
}
