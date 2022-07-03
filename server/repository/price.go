package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreatePrice(db *gorm.DB, ItemID int, input model.PriceInput, args helpers.UserAndStoreArgs) (*model.Price, error) {
	var price *model.Price

	result := db.Where(&model.Price{ItemID: ItemID, CategoryID: input.CategoryID}).Find(&price)

	if result.RowsAffected > 0 {
		return price, nil
	}

	price = &model.Price{
		Amount:     input.Amount,
		CreatorID:  args.UserID,
		CategoryID: input.CategoryID,
		ItemID:     ItemID,
	}

	err := db.Create(&price).Error

	if err != nil {
		return nil, err
	}

	return price, nil
}

func EditPrice(DB *gorm.DB, ItemID int, input model.PriceInput, args helpers.UserAndStoreArgs) (*model.Price, error) {
	var price *model.Price

	price = &model.Price{
		Amount:    input.Amount,
		CreatorID: args.UserID,
	}

	if err := DB.Model(&model.Price{}).Where(&model.Price{ItemID: ItemID, CategoryID: input.CategoryID}).Updates(&price).Error; err != nil {
		return nil, err
	}

	return price, nil
}

func FindPrices(db *gorm.DB, ItemID int) ([]*model.Price, error) {
	var categories []*model.Price
	result := db.Where(&model.Price{ItemID: ItemID}).Find(&categories)
	return categories, result.Error
}

//func FindPrice(db *gorm.DB, ID int) (*model.Price, error) {
//	var price *model.Price
//	result := db.Where(&model.Price{ID: ID}).First(&price)
//	return price, result.Error
//}
