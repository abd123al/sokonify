package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
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
		OrderItems: items,
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
	By := args.By
	Type := args.Type
	Limit := args.Limit
	Offset := args.Offset

	q := DB.Where("orders.customer_id IS NOT NULL") //.Debug()

	//todo handle status
	if By == model.OrdersByStore {
		if args.Mode == model.FetchModeFull {
			StartDate, EndDate := helpers.HandleStatsDates(model.StatsArgs{
				StartDate: args.StartDate,
				EndDate:   args.EndDate,
				Timeframe: args.Timeframe,
			})

			result = q.Where("orders.created_at BETWEEN ? AND ?", StartDate, EndDate).Where(
				q.Where(
					&model.Order{IssuerID: StoreID}).Or(
					&model.Order{ReceiverID: &StoreID})).Where(
				&model.Order{Type: Type}).Order(sort).Find(&orders)
		} else {
			result = q.Where(
				DB.Where(&model.Order{IssuerID: StoreID}).Or(
					&model.Order{ReceiverID: &StoreID})).Where(
				&model.Order{Type: Type}).Order(sort).Limit(*Limit).Offset(*Offset).Find(&orders)
		}
	} else if By == model.OrdersByStaff {
		//Here StaffID is actually userId
		result = q.Where(&model.Order{StaffID: *args.Value, Type: Type}).Order(sort).Limit(*Limit).Offset(*Offset).Find(&orders)
	} else if By == model.OrdersByCustomer {
		result = q.Where(&model.Order{CustomerID: args.Value, Type: Type}).Order(sort).Limit(*Limit).Offset(*Offset).Find(&orders)
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	if result.Error != nil {
		return nil, result.Error
	}

	return orders, nil
}

func FindOrder(db *gorm.DB, ID int) (*model.Order, error) {
	var order *model.Order
	result := db.Where(&model.Order{ID: ID}).First(&order)
	return order, result.Error
}

func FindOrderCustomerName(db *gorm.DB, OrderID int) (*string, error) {
	var name *string

	err := db.Table("orders").Joins("inner join customers on customers.id = orders.customer_id AND orders.id = ?", OrderID).Select("customers.name as name").Row().Scan(&name)
	if err != nil {
		return nil, nil
	}

	return name, nil
}
