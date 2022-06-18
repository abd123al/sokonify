package repository

import (
	"errors"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreatePrice(db *gorm.DB, input model.PriceInput, UserID int) (*model.Price, error) {
	var count int64
	price := model.Price{
		Amount:     input.Amount,
		CreatorID:  UserID,
		CategoryID: input.CategoryID,
		ItemID:     input.ItemID,
	}

	if err := db.Where(&model.Price{ItemID: input.ItemID, CategoryID: input.CategoryID}).Count(&count).Error; err != nil {
		return nil, err
	}

	if count > 0 {
		return nil, errors.New("price in this category was already added")
	}

	result := db.Create(&price)
	return &price, result.Error
}

func EditPrice(DB *gorm.DB, ID int, input model.PriceInput, args helpers.UserAndStoreArgs) (*model.Price, error) {
	var price *model.Price

	price = &model.Price{
		ID:         ID,
		Amount:     input.Amount,
		CreatorID:  args.UserID,
		CategoryID: input.CategoryID,
		ItemID:     input.ItemID,
	}

	if err := DB.Model(&model.Price{}).Where(&model.Price{ID: ID, CreatorID: args.UserID}).Updates(&price).Error; err != nil {
		return nil, err
	}

	return price, nil
}

func FindPrices(db *gorm.DB, ItemID int) ([]*model.Price, error) {
	var categories []*model.Price
	result := db.Where(&model.Price{ItemID: ItemID}).Find(&categories)
	return categories, result.Error
}

func FindPrice(db *gorm.DB, ID int) (*model.Price, error) {
	var price *model.Price
	result := db.Where(&model.Price{ID: ID}).First(&price)
	return price, result.Error
}
