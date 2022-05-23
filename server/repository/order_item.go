package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

// FindOrderItems todo one can access others orders
func FindOrderItems(DB *gorm.DB, OrderID int) ([]*model.OrderItem, error) {
	var items []*model.OrderItem

	result := DB.Where(&model.OrderItem{OrderID: OrderID}).Find(&items)

	if result.Error != nil {
		return nil, result.Error
	}

	return items, nil
}
