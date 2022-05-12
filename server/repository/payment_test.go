package repository_test

import (
	"github.com/shopspring/decimal"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
	"time"
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

	t.Run("sum payments", func(t *testing.T) {
		startDate := time.Now()
		endDate := time.Now().Add(time.Hour * 1)

		var generate = func(length int) (decimal.Decimal, int, decimal.Decimal, decimal.Decimal) {
			staff := util.CreateStaff(DB, nil)
			customer := util.CreateCustomer(DB, staff.StoreID)

			var sum decimal.Decimal
			var orders decimal.Decimal
			var expenses decimal.Decimal

			i := 1
			for i < length+1 {
				result := util.CreatePayment(DB, &util.CreatePaymentArgs{
					StoreID:    staff.StoreID,
					StaffID:    staff.UserID,
					CustomerID: &customer.ID,
				}, i%2 == 0)

				amount, _ := decimal.NewFromString(result.Payment.Amount)
				sum = sum.Add(amount)

				if result.Payment.ExpenseID != nil {
					expenses = expenses.Add(amount)
				} else {
					orders = orders.Add(amount)
				}

				//Increase
				i += 1
			}

			return sum, staff.StoreID, orders, expenses
		}

		//These are payments for other store
		_, _, _, _ = generate(2)
		sum, storeId, orders, expenses := generate(6)

		/**
		Validating sum for all.
		*/
		res1, err1 := repository.SumNetProfit(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Duration:  nil,
		})

		total, _ := decimal.NewFromString(res1)

		assert.Nil(t, err1)
		assert.Equal(t, total.String(), sum.String())

		/**
		Validating expenses for expenses.
		*/
		res2, err2 := repository.SumExpensePayment(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Duration:  nil,
		})

		total2, _ := decimal.NewFromString(res2)

		assert.Nil(t, err2)
		assert.Equal(t, total2.String(), expenses.String())

		/**
		Validating expenses for orders.
		*/
		res3, err3 := repository.SumOrderPayments(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Duration:  nil,
		})

		total3, _ := decimal.NewFromString(res3)

		assert.Nil(t, err3)
		assert.Equal(t, total3.String(), orders.String())

		//Overall
		assert.Equal(t, sum.String(), orders.Add(expenses).String())
	})

	t.Run("sum payments should not raise error for 0 amount", func(t *testing.T) {
		staff := util.CreateStaff(DB, nil)

		startDate := time.Now()
		endDate := time.Now().Add(time.Hour * 1)

		res, err := repository.SumNetProfit(DB, staff.StoreID, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Duration:  nil,
		})

		assert.Nil(t, err)
		assert.Equal(t, res, "0.00")
	})
}
