package repository_test

import (
	"fmt"
	"github.com/shopspring/decimal"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/helpers"
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
				OrderID:     order.Order.ID,
				Description: nil,
				ReferenceID: nil,
				Method:      model.PaymentMethodCash,
			})

			return p, e
		}

		payment, err := call()

		require.Nil(t, err)
		require.NotNil(t, payment)

		payment2, err2 := call()

		//Won't work because order is already completed
		require.NotNil(t, err2)
		require.Nil(t, payment2)
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

		require.Nil(t, item)
		require.NotNil(t, err)
	})

	pay := func(Order bool) *util.CreatePaymentResult {
		re := util.CreatePayment(DB, &util.CreatePaymentArgs{
			StoreID:    store.ID,
			StaffID:    user.ID,
			CustomerID: &util.CreateCustomer(DB, store.ID).ID,
		}, Order)

		return &re
	}

	t.Run("FindPayments by store", func(t *testing.T) {
		re := pay(false)
		require.NotNil(t, re.Payment)

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:   model.PaymentsByStore,
			Mode: model.FetchModeFull,
			Type: model.PaymentTypeExpense,
		}, re.StoreID)

		require.Nil(t, err)
		require.NotEmpty(t, paymentsByCustomer)
	})

	t.Run("FindPayments by store with pagination", func(t *testing.T) {
		re := pay(false)
		_ = pay(false)

		offset := 1
		limit := 10

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:     model.PaymentsByStore,
			Mode:   model.FetchModePagination,
			Limit:  &limit,
			Offset: &offset,
			Type:   model.PaymentTypeExpense,
		}, re.StoreID)

		require.Nil(t, err)
		require.NotEmpty(t, paymentsByCustomer)
	})

	t.Run("FindPayments by customer using FetchModeFull", func(t *testing.T) {
		result := pay(true)

		paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
			By:    model.PaymentsByCustomer,
			Value: result.CustomerID,
			Mode:  model.FetchModeFull,
		}, result.StoreID)

		require.Nil(t, err)
		require.NotEmpty(t, paymentsByCustomer)
	})

	//t.Run("FindPayments by staff", func(t *testing.T) {
	//	result := util.CreatePayment(DB, nil, false)
	//
	//	paymentsByCustomer, err := repository.FindPayments(DB, model.PaymentsArgs{
	//		By:     model.PaymentsByStaff,
	//		Value:  &result.StaffID,
	//		Limit:  10,
	//		Offset: 0,
	//	})
	//
	//	require.Nil(t, err)
	//	require.NotEmpty(t, paymentsByCustomer)
	//})

	t.Run("sum payments by dates", func(t *testing.T) {
		startDate := time.Now()
		endDate := time.Now().Add(time.Hour * 1)
		period := model.TimeframeTypeThisMonth

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
					StaffID:    staff.Staff.UserID,
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
		res1, err1 := repository.SumNetIncome(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Timeframe: nil,
		})

		//using period
		res1a, err1a := repository.SumNetIncome(DB, storeId, model.StatsArgs{
			Timeframe: &period,
		})

		require.Nil(t, err1a)
		require.Equal(t, res1, res1a)

		total, _ := decimal.NewFromString(res1)

		require.Nil(t, err1)
		require.Equal(t, total.String(), sum.String())

		/**
		Validating expenses for expenses.
		*/
		res2, err2 := repository.SumExpensePayment(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Timeframe: nil,
		})

		total2, _ := decimal.NewFromString(res2)

		require.Nil(t, err2)
		require.Equal(t, total2.String(), expenses.String())

		/**
		Validating expenses for orders.
		*/
		res3, err3 := repository.SumOrderPayments(DB, storeId, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Timeframe: nil,
		})

		total3, _ := decimal.NewFromString(res3)

		require.Nil(t, err3)
		require.Equal(t, total3.String(), orders.String())

		//Overall
		require.Equal(t, sum.String(), orders.Add(expenses).String())
	})

	t.Run("sum payments should not raise error for 0 amount", func(t *testing.T) {
		staff := util.CreateStaff(DB, nil)

		startDate := time.Now()
		endDate := time.Now().Add(time.Hour * 1)

		res, err := repository.SumNetIncome(DB, staff.StoreID, model.StatsArgs{
			StartDate: &startDate,
			EndDate:   &endDate,
			Timeframe: nil,
		})

		require.Nil(t, err)
		require.Equal(t, res, "0.00")
	})

	t.Run("CreateSale", func(t *testing.T) {
		item := util.CreateItem(DB, util.CreateItemArgs{
			StoreID: store.ID,
		})

		payment, err := repository.CreateSalePayment(DB, model.SalesInput{
			Items: []*model.OrderItemInput{
				{
					Quantity: item.Quantity,
					Price:    item.Prices[0].Amount,
					ItemID:   item.ID,
				},
			},
		}, helpers.UserAndStoreArgs{
			UserID:  user.ID,
			StoreID: store.ID,
		})

		require.Nil(t, err)
		require.NotNil(t, payment)
	})

	t.Run("SumGrossProfit", func(t *testing.T) {
		re := util.CreatePayment(DB, nil, true)

		timeframe := model.TimeframeTypeToday
		value := re.Payment.ID
		filter := model.StatsFilterPayment

		profit, err := repository.SumGrossProfit(DB, re.StoreID, model.StatsArgs{
			Timeframe: &timeframe,
			PricingID: re.PricingID,
			Value:     &value,
			Filter:    &filter,
		})

		//fmt.Printf("Profit %v\n", profit)
		fmt.Printf("Profit %s\n", profit.Real)
		fmt.Printf("Expected %s\n", profit.Expected)
		fmt.Printf("Sales %s\n", profit.Sales)

		require.Nil(t, err)
		require.NotEmpty(t, profit)
	})

	t.Run("SumGrossProfit to return zero when nothing found", func(t *testing.T) {
		timeframe := model.TimeframeTypeToday

		profit, err := repository.SumGrossProfit(DB, store.ID, model.StatsArgs{
			Timeframe: &timeframe,
		})

		fmt.Printf("Profit %s\n", profit.Real)
		fmt.Printf("Expected %s\n", profit.Expected)
		fmt.Printf("Sales %s\n", profit.Sales)

		require.Nil(t, err)
		require.NotNil(t, profit)
		require.NotEmpty(t, profit.Real)
		require.NotEmpty(t, profit.Expected)
		require.NotEmpty(t, profit.Sales)
	})
}
