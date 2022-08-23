package repository

import (
	"errors"
	"fmt"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"strconv"
)

func CreateSalePayment(DB *gorm.DB, input model.SalesInput, args helpers.UserAndStoreArgs) (*model.Payment, error) {
	var payment *model.Payment

	err := DB.Transaction(func(tx *gorm.DB) error {
		order, err := CreateOrder(tx, args.UserID, model.OrderInput{
			Type:       model.OrderTypeSale,
			Items:      input.Items,
			CustomerID: nil,
			PricingID:  input.PricingID,
		}, args.StoreID)

		if err != nil {
			return err
		}

		payment, err = CreateOrderPayment(tx, args.UserID, model.OrderPaymentInput{
			OrderID:     order.ID,
			Description: input.Comment,
		})

		return nil
	})

	if err != nil {
		return nil, err
	}

	return payment, nil
}

// CreateOrderPayment todo loans
func CreateOrderPayment(DB *gorm.DB, StaffID int, input model.OrderPaymentInput) (*model.Payment, error) {
	var payment *model.Payment

	err := DB.Transaction(func(tx *gorm.DB) error {
		var order *model.Order
		var orderItems []model.OrderItem
		var subPrice decimal.Decimal

		//Finding order so that we know its types
		if err := tx.Where(&model.Order{ID: input.OrderID}).First(&order).Error; err != nil {
			return err
		}

		if order.Status != model.OrderStatusPending {
			return errors.New(`order has already been completed..'`)
		}

		//Finding all items which are on order
		if err := tx.Where(&model.OrderItem{OrderID: input.OrderID}).Find(&orderItems).Error; err != nil {
			return err
		}

		//Summing the total price.
		for _, o := range orderItems {
			price, err := decimal.NewFromString(o.Price)
			if err != nil {
				panic(err)
			}
			total := price.Mul(decimal.NewFromInt(int64(o.Quantity)))

			subPrice = subPrice.Add(total)
		}

		//Saving payment
		payment = &model.Payment{
			OrderID:     &input.OrderID,
			StaffID:     StaffID,
			Description: input.Description,
			ReferenceID: input.ReferenceID,
			Method:      input.Method,
			Amount:      subPrice.String(),
		}

		//We think + and - in terms of cash movement
		//todo we should make sure amount comes unsigned.
		if order.Type == model.OrderTypePurchase || order.Type == model.OrderTypeLoss {
			payment.Amount = "-" + payment.Amount
		} else if order.Type == model.OrderTypeSale {
			payment.Amount = "+" + payment.Amount
		} else if order.Type == model.OrderTypeTransfer {
			return errors.New(`you can't save payment for transfer order.'`)
		} else {
			return errors.New(order.Type.String() + " is not implemented in payments.")
		}

		// do some database operations in the transaction (use 'tx' from this point, not 'db')
		if err := tx.Create(&payment).Error; err != nil {
			return err
		}

		//Updating order so that it will not be later updated
		if err := tx.Model(model.Order{}).Where(model.Order{ID: input.OrderID, Status: model.OrderStatusPending}).Updates(model.Order{Status: model.OrderStatusCompleted}).Error; err != nil {
			return err
		}

		//Decreasing items' quantity depending on type
		for _, i := range orderItems {
			result := tx.Model(&model.Item{}).Where(&model.Item{ID: i.ItemID}).Where("quantity >= "+strconv.Itoa(i.Quantity)).Update("quantity", gorm.Expr("quantity - ?", i.Quantity))

			//This will make the whole process abort since item is out of stock.
			if result.RowsAffected == 0 {
				err := CheckAvailableQuantity(DB, &model.OrderItemInput{
					Quantity: i.Quantity,
					ItemID:   i.ItemID,
				})

				if err != nil {
					return err
				}
			}

			if result.Error != nil {
				return result.Error
			}
		}

		// return nil will commit the whole transaction
		return nil
	})

	return payment, err
}

func CreateExpensePayment(DB *gorm.DB, StaffID int, input model.ExpensePaymentInput) (*model.Payment, error) {
	var expense *model.Expense

	res := DB.Where(&model.Expense{ID: input.ExpenseID}).Find(&expense)
	if res.Error != nil || res.RowsAffected == 0 {
		return nil, errors.New("expense not found")
	}

	payment := &model.Payment{
		ExpenseID:   &input.ExpenseID,
		StaffID:     StaffID,
		Description: input.Description,
		ReferenceID: input.ReferenceID,
		Method:      input.Method,
		Amount:      input.Amount,
	}

	//Put sign depending on type of expense
	if expense.Type == model.ExpenseTypeOut {
		//This means money has gone out
		payment.Amount = "-" + payment.Amount
	}

	result := DB.Create(&payment)

	return payment, result.Error
}

func FindPayment(db *gorm.DB, ID int) (*model.Payment, error) {
	var payment *model.Payment
	result := db.Where(&model.Payment{ID: ID}).First(&payment)
	return payment, result.Error
}

func FindPaymentByOrderId(db *gorm.DB, OrderID int) (*model.Payment, error) {
	var payment *model.Payment
	if r := db.Where(&model.Payment{OrderID: &OrderID}).Find(&payment).RowsAffected; r > 0 {
		return payment, nil
	}
	return nil, nil
}

// FindPayments todo make it use time like order
func FindPayments(DB *gorm.DB, args model.PaymentsArgs, StoreID int) ([]*model.Payment, error) {
	var payments []*model.Payment
	var result *gorm.DB

	sort := "payments.id " + "DESC" //todo use sortBy var
	By := args.By
	Limit := args.Limit
	Offset := args.Offset

	StartDate, EndDate := helpers.HandleStatsDates(model.StatsArgs{
		StartDate: args.StartDate,
		EndDate:   args.EndDate,
		Timeframe: args.Timeframe,
	})

	db := DB.Table("payments") //.Debug() //todo filter payments

	if By == model.PaymentsByStore {
		var q *gorm.DB
		if args.Type == model.PaymentTypeOrder {
			q = db.Order(sort).Joins("inner join orders on orders.id = payments.order_id AND orders.issuer_id = ?", StoreID)
		} else {
			q = db.Order(sort).Joins("inner join expenses on expenses.id = payments.expense_id AND expenses.store_id = ?", StoreID)
		}

		if args.Mode == model.FetchModeFull {
			result = q.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Find(&payments)
		} else {
			result = q.Offset(*Offset).Limit(*Limit).Find(&payments)
		}
	} else if By == model.PaymentsByStaff {
		//This will return payments processed by a specific staff.
		panic(fmt.Errorf("not implemented"))
	} else if By == model.PaymentsByCustomer {
		//This will return payments by specific customer.
		a := db.Order(sort)
		b := a.Joins("inner join orders on orders.id = payments.order_id AND orders.customer_id = ?", args.Value)

		if args.Mode == model.FetchModeFull {
			result = b.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Find(&payments)
		} else {
			result = b.Offset(*Offset).Limit(*Limit).Find(&payments)
		}
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	if result.Error != nil {
		return nil, result.Error
	}

	return payments, nil
}

func SumNetIncome(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	var amount string
	StartDate, EndDate := helpers.HandleStatsDates(args)

	a := db.Table("payments")
	b := a.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate)
	c := b.Joins("inner join staffs on payments.staff_id = staffs.user_id")
	d := c.Joins("inner join categories on staffs.role_id = categories.id AND categories.store_id = ?", StoreID)
	if err := d.Select("sum(amount)").Row().Scan(&amount); err != nil {
		return "0.00", nil
	}

	return amount, nil
}

func SumOrderPayments(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	re, er := SumGrossProfit(db, StoreID, args)

	return re.Sales, er
}

func SumExpensePayment(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	var amount string
	StartDate, EndDate := helpers.HandleStatsDates(args)

	a := db.Table("payments")
	b := a.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate)
	c := b.Joins("inner join expenses on expenses.id = payments.expense_id AND expenses.store_id = ?", StoreID)

	if err := c.Select("coalesce(sum(amount),0)").Row().Scan(&amount); err != nil {
		return "0.00", err
	}

	return amount, nil
}

// GetOrderItemsFilters / This is reused in finding items too
func GetOrderItemsFilters(db *gorm.DB, StoreID int, args model.StatsArgs) *gorm.DB {
	StartDate, EndDate := helpers.HandleStatsDates(args)

	a := db.Table("order_items")
	b := a.Joins("inner join items on order_items.item_id = items.id")
	c := b.Joins("inner join orders on order_items.order_id = orders.id AND orders.issuer_id = ? AND orders.status = ?", StoreID, model.OrderStatusCompleted)
	d := c.Joins("inner join payments on orders.id = payments.order_id")

	var y = d
	var isDateDependent = true

	if args.Filter != nil && args.Value != nil {
		//todo later we can combine filters
		if *args.Filter == model.StatsFilterProductsCategory {
			y = d.Joins("inner join product_categories ON product_categories.product_id = items.product_id AND product_categories.category_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterStocksCategory {
			y = d.Joins("inner join product_categories ON product_categories.item_id = items.id AND product_categories.category_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterBrand {
			y = d.Where("items.brand_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterItem {
			y = d.Where("items.id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterProduct {
			y = d.Where("items.product_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterCustomer {
			y = d.Where("orders.customer_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterStaff {
			y = d.Where("payments.staff_id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterPayment {
			isDateDependent = false
			y = d.Where("payments.id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterOrder {
			isDateDependent = false
			y = d.Where("orders.id = ?", args.Value)
		} else if *args.Filter == model.StatsFilterPricing {
			y = d.Joins("inner join prices on prices.item_id = items.id AND prices.category_id = ?", args.Value)
		}
	}

	var f = y

	if isDateDependent {
		f = y.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate)
	}

	return f
}

func SumGrossProfit(db *gorm.DB, StoreID int, args model.StatsArgs) (*model.Profit, error) {
	var profit *model.Profit

	var f = GetOrderItemsFilters(db, StoreID, args)

	g := f.Select(`
COALESCE(SUM((order_items.price - items.buying_price) * order_items.quantity),0.00) AS real, 
COALESCE(SUM(order_items.price * order_items.quantity),0.00) AS sales
`)

	if err := g.Scan(&profit).Error; err != nil {
		return nil, err
	}

	return profit, nil
}

func SumGrossProfitsByDay(db *gorm.DB, StoreID int, args model.StatsArgs) ([]*model.Profit, error) {
	var profit []*model.Profit

	f := GetOrderItemsFilters(db, StoreID, args)

	g := f.Table("order_items").Select(`
DATE_TRUNC('day', order_items.created_at) as day,
COALESCE(SUM((order_items.price - items.buying_price) * order_items.quantity),0.00) AS real, 
COALESCE(SUM(order_items.price * order_items.quantity),0.00) AS sales
`).Group("day")

	if err := g.Scan(&profit).Error; err != nil {
		return nil, err
	}

	return profit, nil
}
