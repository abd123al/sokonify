package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func isOrderCompleted(db *gorm.DB, OrderID int) (*model.Order, error) {
	order, err := FindOrder(db, OrderID)
	if err != nil {
		return nil, err
	}

	if order.Status != model.OrderStatusPending {
		return nil, fmt.Errorf("order is already %s", order.Status)
	}

	return order, nil
}

func CreateOrderItems(db *gorm.DB, OrderID int, input []*model.OrderItem) ([]*model.OrderItem, error) {
	_, e := isOrderCompleted(db, OrderID)
	if e != nil {
		return nil, e
	}

	result := db.Model(&model.OrderItem{}).Create(&input)
	return input, result.Error
}

func EditOrderItem(db *gorm.DB, OrderID int, input model.OrderItemInput) (*model.OrderItem, error) {
	_, e := isOrderCompleted(db, OrderID)
	if e != nil {
		return nil, e
	}

	o := model.OrderItem{
		OrderID:  OrderID,
		ItemID:   input.ItemID,
		Quantity: input.Quantity,
		Price:    input.Price,
	}

	if err := db.Model(&model.OrderItem{}).Where(&model.OrderItem{OrderID: OrderID, ItemID: input.ItemID}).Updates(&o).Error; err != nil {
		return nil, err
	}

	return &o, nil
}

func DeleteOrderItem(db *gorm.DB, OrderID int, ItemID int) (*model.OrderItem, error) {
	_, e := isOrderCompleted(db, OrderID)
	if e != nil {
		return nil, e
	}

	o := model.OrderItem{
		OrderID: OrderID,
		ItemID:  ItemID,
	}

	if err := db.Model(&model.OrderItem{}).Where(&model.OrderItem{OrderID: OrderID, ItemID: ItemID}).Delete(&o).Error; err != nil {
		return nil, err
	}

	return &o, nil
}

// FindOrderItems todo one can access others orders
func FindOrderItems(DB *gorm.DB, OrderID int) ([]*model.OrderItem, error) {
	var items []*model.OrderItem

	result := DB.Where(&model.OrderItem{OrderID: OrderID}).Find(&items)

	if result.Error != nil {
		return nil, result.Error
	}

	return items, nil
}

func DeleteOrderItems(DB *gorm.DB, OrderID int) ([]*model.OrderItem, error) {
	var items []*model.OrderItem

	result := DB.Where(&model.OrderItem{OrderID: OrderID}).Delete(&items)

	if result.Error != nil {
		return nil, result.Error
	}

	return items, nil
}

func FindSoldItems(DB *gorm.DB, StoreID int, args model.StatsArgs) ([]*model.OrderItem, error) {
	var items []*model.OrderItem

	var f = GetOrderItemsFilters(DB, StoreID, args)

	result := f.Find(&items)

	if result.Error != nil {
		return nil, result.Error
	}

	return items, nil
}
