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
}
