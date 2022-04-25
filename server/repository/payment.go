package repository

import (
	"errors"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

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
		if order.Type == model.OrderTypeOut || order.Type == model.OrderTypeLoss {
			payment.Amount = "-" + payment.Amount
		} else if order.Type == model.OrderTypeIn {
			payment.Amount = "+" + payment.Amount
		} else if order.Type == model.OrderTypeNeutral {
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
		//todo don't allow zero
		for _, i := range orderItems {
			if err := tx.Model(&model.Item{}).Where(&model.Item{ID: i.ItemID}).Update("quantity", gorm.Expr("quantity - ?", i.Quantity)).Error; err != nil {
				return err
			}
		}

		// return nil will commit the whole transaction
		return nil
	})

	return payment, err
}

func CreateExpensePayment(DB *gorm.DB, StaffID int, input model.ExpensePaymentInput) (*model.Payment, error) {
	var expense *model.Expense

	if err := DB.Where(&model.Expense{ID: input.ExpenseID}).First(&expense).Error; err != nil {
		return nil, err
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