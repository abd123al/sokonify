package repository

import (
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateOrderPayment(DB *gorm.DB, StaffID int, input model.OrderPaymentInput) (*model.Payment, error) {
	var payment *model.Payment

	err := DB.Transaction(func(tx *gorm.DB) error {
		var orderItems []model.OrderItem
		var subPrice decimal.Decimal

		//Finding all items which are on order
		tx.Where(&model.OrderItem{OrderID: input.OrderID}).Find(&orderItems)

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

		// do some database operations in the transaction (use 'tx' from this point, not 'db')
		if err := tx.Create(&payment).Error; err != nil {
			return err
		}

		//Changing ledger

		//Decreasing items' quantity depending on type

		// return nil will commit the whole transaction
		return nil
	})

	return payment, err
}
