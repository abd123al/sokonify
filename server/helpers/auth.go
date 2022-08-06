package helpers

import (
	"context"
	"encoding/json"
	"github.com/go-chi/jwtauth"
	"mahesabu/graph/model"
	"time"
)

type AuthParams struct {
	UserID      int      `json:"user_id"`
	RoleID      int      `json:"role_id"`
	StoreID     int      `json:"store_id"`
	IsOwner     bool     `json:"is_owner"`
	Permissions []string `json:"permissions,omitempty"`
	Prices      []int    `json:"prices,omitempty"`
}

type FindDefaultStoreAndRoleResult struct {
	StoreID int
	RoleID  int
	OwnerId int
	//todo this should not be here. We should find permission based on roleId this will make it easier to revoke..
	Permissions []*model.Permission `json:"permissions" gorm:"-"`
}

func GenerateAuthToken(UserID int, args *FindDefaultStoreAndRoleResult) string {
	var myMap map[string]interface{}

	payload := AuthParams{
		UserID: UserID,
	}

	if args != nil {
		payload.StoreID = args.StoreID
		payload.RoleID = args.RoleID
		payload.IsOwner = args.OwnerId == UserID

		if args.Permissions != nil {
			//This is used to allow access to operations
			var permissions []string
			//This is used to allow selling items according to some kind of pricing.
			var prices []int

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

	jwtauth.SetIssuedNow(myMap)
	jwtauth.SetExpiry(myMap, time.Now().Add(time.Hour*12))

	_, tokenString, _ := TokenAuth.Encode(myMap)

	return tokenString
}

// ForContext finds the user from the context. REQUIRES Middleware to have run.
func ForContext(ctx context.Context) *AuthParams {
	_, claims, _ := jwtauth.FromContext(ctx)

	return ExtractAuthParams(claims)
}

func ExtractAuthParams(claims map[string]interface{}) *AuthParams {
	var permissions []string
	var prices []int

	userId := int(claims["user_id"].(float64))
	StoreID := int(claims["store_id"].(float64))
	RoleID := int(claims["role_id"].(float64))
	IsOwner := claims["is_owner"].(bool)

	if k, ok := claims["permissions"]; ok {
		if k != nil {
			for _, s := range k.([]interface{}) {
				permissions = append(permissions, s.(string))
			}
		}
	}

	if k, ok := claims["prices"]; ok {
		if k != nil {
			for _, s := range k.([]interface{}) {
				prices = append(prices, int(s.(float64)))
			}
		}
	}

	params := AuthParams{
		UserID:      userId,
		StoreID:     StoreID,
		RoleID:      RoleID,
		IsOwner:     IsOwner,
		Permissions: permissions,
		Prices:      prices,
	}

	return &params
}
