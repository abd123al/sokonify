package repository

import (
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreatePayment(DB *gorm.DB, StaffID int, input model.PaymentInput) (*model.Payment, error) {
	var payment *model.Payment

	err := DB.Transaction(func(tx *gorm.DB) error {
		//todo should the order creator be the one to confirm payment.
		var orderItems []model.OrderItem
		var subPrice decimal.Decimal

		tx.Where(&model.OrderItem{OrderID: input.OrderID}).Find(&orderItems)

		for _, o := range orderItems {
			price, err := decimal.NewFromString(o.Price)
			if err != nil {
				panic(err)
			}
			total := price.Mul(decimal.NewFromInt(int64(o.Quantity)))

			subPrice = subPrice.Add(total)
		}

		payment = &model.Payment{
			OrderID:     input.OrderID,
			StaffID:     StaffID,
			Description: input.Description,
			ReferenceID: input.ReferenceID,
			Type:        input.Type,
			Amount:      subPrice.String(),
		}

		// do some database operations in the transaction (use 'tx' from this point, not 'db')
		if err := tx.Create(&payment).Error; err != nil {
			return err
		}

		// return nil will commit the whole transaction
		return nil
	})

	return payment, err
}
