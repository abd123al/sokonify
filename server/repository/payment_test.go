package repository_test

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestPayment(t *testing.T) {
	DB := util.InitTestDB()
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)

	t.Run("CreateOrderPayment", func(t *testing.T) {
		order := util.CreateOrder(DB, nil)

		var call = func() (*model.Payment, error) {
			p, e := repository.CreateOrderPayment(DB, user.ID, model.OrderPaymentInput{
				OrderID:     order.ID,
				Description: nil,
				ReferenceID: nil,
				Method:      model.PaymentMethodCash,
			})

			return p, e
		}

		payment, err := call()

		assert.Nil(t, err)
		assert.NotNil(t, payment)

		payment2, err2 := call()

		//Won't work because order is already completed
		assert.NotNil(t, err2)
		assert.Nil(t, payment2)
	})

	t.Run("CreateExpensePayment", func(t *testing.T) {
		expense := util.CreateExpense(DB, &store.ID)

		item, _ := repository.CreateExpensePayment(DB, user.ID, model.ExpensePaymentInput{
			ExpenseID: expense.ID,
			Amount:    "5000.00",
			Method:    model.PaymentMethodCash,
		})

		require.GreaterOrEqual(t, item.ID, 1)
	})

	t.Run("throw error when expense not found", func(t *testing.T) {
		item, err := repository.CreateExpensePayment(DB, user.ID, model.ExpensePaymentInput{
			ExpenseID: 12333,
			Amount:    "5000.00",
			Method:    model.PaymentMethodCash,
		})

		assert.Nil(t, item)
		assert.NotNil(t, err)
	})

	t.Run("FindPayments by store", func(t *testing.T) {
		result := util.CreatePayment(DB, nil, false)

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:    model.PaymentsByStore,
			Value: result.StoreID,
		})

		assert.Nil(t, err)
		assert.NotEmpty(t, paymentsByCustomer)
	})

	t.Run("FindPayments by customer", func(t *testing.T) {
		result := util.CreatePayment(DB, nil, true)

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:    model.PaymentsByCustomer,
			Value: *result.CustomerID,
		})

		assert.Nil(t, err)
		assert.NotEmpty(t, paymentsByCustomer)
	})

	t.Run("FindPayments by staff", func(t *testing.T) {
		result := util.CreatePayment(DB, nil, false)

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:     model.PaymentsByStaff,
			Value:  result.StaffID,
			Limit:  10,
			Offset: 0,
		})

		assert.Nil(t, err)
		assert.NotEmpty(t, paymentsByCustomer)
	})
}
