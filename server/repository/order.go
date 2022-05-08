package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"strconv"
)

func CreateOrder(DB *gorm.DB, UserId int, input model.OrderInput, StoreID int) (*model.Order, error) {
	var items []*model.OrderItem

	for _, k := range input.Items {
		//Checking item's quantity if is enough for fulfilling order...
		var item *model.Item
		result := DB.Where(&model.Item{ID: k.ItemID}).Where("quantity >= " + strconv.Itoa(k.Quantity)).Find(&item)
		if result.RowsAffected == 0 {
			//todo friendly message with product name
			return nil, errors.New(fmt.Sprintf("Item %d stock is not enough", k.ItemID))
		}

		i := model.OrderItem{
			Price:    k.Price,
			ItemID:   k.ItemID,
			Quantity: k.Quantity,
		}

		items = append(items, &i)
	}

	order := model.Order{
		ReceiverID: input.ReceiverID,
		IssuerID:   StoreID,
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

func FindOrders(DB *gorm.DB, args model.OrdersArgs, StoreID int) ([]*model.Order, error) {
	var orders []*model.Order
	var result *gorm.DB
	sort := "id " + "DESC" //todo use sortBy var

	//todo handle status
	if args.By == model.OrdersByStore {
		result = DB.Where(
			DB.Where(&model.Order{IssuerID: StoreID}).Or(&model.Order{ReceiverID: &StoreID})).Where(&model.Order{Type: args.Type}).Order(sort).Limit(args.Limit).Offset(args.Offset).Find(&orders)
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

func FindOrder(db *gorm.DB, ID int) (*model.Order, error) {
	var order *model.Order
	result := db.Where(&model.Order{ID: ID}).First(&order)
	return order, result.Error
}
