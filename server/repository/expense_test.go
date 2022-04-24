package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestFindExpenses(t *testing.T) {
	DB := util.InitTestDB()
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)

	t.Run("CreateExpensePayment", func(t *testing.T) {
		util.CreateExpense(DB, &store.ID)
		util.CreateExpense(DB, &store.ID)
		util.CreateExpense(DB, &store.ID)

		otherStore := util.CreateStore(DB, &user.ID)
		util.CreateExpense(DB, &otherStore.ID) //Not to be returned

		results, _ := repository.FindExpenses(DB, model.ExpensesArgs{
			By:    model.ExpensesByStore,
			Value: store.ID,
		})

		require.GreaterOrEqual(t, len(results), 3)
	})
}
