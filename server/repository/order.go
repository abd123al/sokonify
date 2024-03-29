package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateOrder(DB *gorm.DB, UserId int, input model.OrderInput, StoreID int) (*model.Order, error) {
	var items []*model.OrderItem

	for _, required := range input.Items {
		err := CheckAvailableQuantity(DB, required)

		if err != nil {
			return nil, err
		}

		i := model.OrderItem{
			Price:    required.Price,
			ItemID:   required.ItemID,
			Quantity: required.Quantity,
		}

		items = append(items, &i)
	}

	order := model.Order{
		ReceiverID: input.ReceiverID,
		IssuerID:   StoreID,
		CustomerID: input.CustomerID,
		PricingID:  input.PricingID,
		StaffID:    UserId,
		Type:       input.Type,
		OrderItems: items,
		Status:     model.OrderStatusPending, //Important
		Comment:    input.Comment,
	}

	//fmt.Printf("%+v\n\n", order.Items[0].ItemID)

	result := DB.Create(&order)
	return &order, result.Error
}

func EditOrder(DB *gorm.DB, ID int, input model.OrderInput, args helpers.UserAndStoreArgs) (*model.Order, error) {
	var items []*model.OrderItem
	var order *model.Order

	err := DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where(&model.Order{ID: ID, StaffID: args.UserID}).First(&order).Error; err != nil {
			return err
		}

		if order.Status != model.OrderStatusPending {
			return fmt.Errorf(`order is already %s, you can't edit it`, order.Status)
		}

		order.ReceiverID = input.ReceiverID
		order.CustomerID = input.CustomerID
		order.Comment = input.Comment

		if err := tx.Save(&order).Error; err != nil {
			return err
		}

		//Finding previous order items and then compare them
		_, err := DeleteOrderItems(tx, ID)

		if err != nil {
			return err
		}

		for _, u := range input.Items {
			err := CheckAvailableQuantity(tx, u)

			if err != nil {
				return err
			}

			i := model.OrderItem{
				OrderID:  ID,
				Price:    u.Price,
				ItemID:   u.ItemID,
				Quantity: u.Quantity,
			}

			items = append(items, &i)
		}

		orderItems, err := CreateOrderItems(tx, ID, items)
		if err != nil {
			return err
		}

		order.OrderItems = orderItems

		return nil
	})

	if err != nil {
		return nil, err
	}

	return order, nil
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
