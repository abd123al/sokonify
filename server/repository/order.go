package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateOrder(DB *gorm.DB, UserId int, input model.OrderInput) (*model.Order, error) {
	var items []*model.OrderItem

	for _, k := range input.Items {
		item := model.OrderItem{
			Price:    k.Price,
			ItemID:   k.ItemID,
			Quantity: k.Quantity,
		}

		items = append(items, &item)
	}

	order := model.Order{
		ReceiverID: input.ReceiverID,
		IssuerID:   input.IssuerID,
		CustomerID: input.CustomerID,
		StaffID:    UserId,
		Type:       input.Type,
		Items:      items,
		Status:     model.OrderStatusPending, //Important
	}

	//fmt.Printf("%+v\n\n", order.Items[0].ItemID)

	result := DB.Create(&order)
	return &order, result.Error
}

func Orders(DB *gorm.DB, args model.OrdersArgs) ([]*model.Order, error) {
	var orders []*model.Order
	var result *gorm.DB
	sort := "id " + "DESC" //todo use sortBy var

	//todo handle status
	if args.By == model.OrdersByStore {
		result = DB.Where(
			DB.Where(&model.Order{IssuerID: args.Value}).Or(&model.Order{ReceiverID: &args.Value})).Where(&model.Order{Type: args.Type}).Order(sort).Limit(args.Limit).Offset(args.Offset).Find(&orders)
	} else if args.By == model.OrdersByStaff {
		//Here StaffID is actually userId
		result = DB.Where(&model.Order{StaffID: args.Value, Type: args.Type}).Order(sort).Limit(args.Limit).Offset(args.Offset).Find(&orders)
	} else if args.By == model.OrdersByCustomer {
		result = DB.Where(&model.Order{CustomerID: &args.Value, Type: args.Type}).Order(sort).Limit(args.Limit).Offset(args.Offset).Find(&orders)
	} else {
		panic(fmt.Errorf("not implemented"))
	}
	return orders, result.Error
}
