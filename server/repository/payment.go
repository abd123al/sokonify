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
				return errors.New(fmt.Sprintf("Item %d is out of stock", i.ID))
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

	sort := "id " + "DESC" //todo use sortBy var
	By := args.By
	//Type := args.Type
	//Limit := args.Limit
	//Offset := args.Offset

	q := DB //.Debug() //todo filter payments

	//partialQuery := q.Table("payments").Order("id DESC").Offset(*Offset).Limit(*Limit).Order(sort)

	if By == model.PaymentsByStore {
		if args.Mode == model.FetchModeFull {
			StartDate, EndDate := helpers.HandleStatsDates(model.StatsArgs{
				StartDate: args.StartDate,
				EndDate:   args.EndDate,
				Timeframe: args.Timeframe,
			})

			result = q.Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Order(sort).Joins("inner join staffs on payments.staff_id = staffs.user_id AND staffs.store_id = ?", StoreID).Find(&payments)
		} else {
			//This will return all payments store processed.
			//result = partialQuery.Joins("inner join staffs on payments.staff_id = staffs.user_id AND staffs.store_id = ?", args.Value).Find(&payments)
		}
	} else if By == model.PaymentsByStaff {
		//This will return payments processed by a specific staff.
		//result = partialQuery.Where(&model.Payment{StaffID: *args.Value}).Find(&payments)
	} else if By == model.PaymentsByCustomer {
		//This will return payments by specific customer.
		//result = partialQuery.Joins("inner join orders on payments.order_id = orders.id AND orders.customer_id = ?", args.Value).Find(&payments)
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

	if err := db.Table("payments").Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Joins("inner join staffs on payments.staff_id = staffs.user_id AND staffs.store_id = ?", StoreID).Select("sum(amount)").Row().Scan(&amount); err != nil {
		return "0.00", nil
	}

	return amount, nil
}

func SumExpensePayment(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	return sumPaymentType(db, StoreID, args, model.PaymentTypeExpense)
}

func SumOrderPayments(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	return sumPaymentType(db, StoreID, args, model.PaymentTypeOrder)
}

func sumPaymentType(db *gorm.DB, StoreID int, args model.StatsArgs, t model.PaymentType) (string, error) {
	var amount string
	StartDate, EndDate := helpers.HandleStatsDates(args)

	var column string

	if t == model.PaymentTypeExpense {
		column = "expense_id"
	} else {
		column = "order_id"
	}

	if err := db.Table("payments").Where(fmt.Sprintf("%s is not null", column)).Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Joins("inner join staffs on payments.staff_id = staffs.user_id AND staffs.store_id = ?", StoreID).Select("sum(amount)").Row().Scan(&amount); err != nil {
		return "0.00", nil
	}

	return amount, nil
}

func SumNetProfit(db *gorm.DB, StoreID int, args model.StatsArgs) (string, error) {
	var amount string
	StartDate, EndDate := helpers.HandleStatsDates(args)

	if err := db.Table("payments").Where("payments.created_at BETWEEN ? AND ?", StartDate, EndDate).Joins("inner join staffs on payments.staff_id = staffs.user_id AND staffs.store_id = ?", StoreID).Select("sum(amount)").Row().Scan(&amount); err != nil {
		return "0.00", nil
	}

	return amount, nil
}
