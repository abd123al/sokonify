package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

func CreateExpense(DB *gorm.DB, input model.ExpenseInput) (*model.Expense, error) {
	expense := model.Expense{
		Name:    input.Name,
		Type:    input.Type,
		StoreID: input.StoreID,
	}

	result := DB.Create(&expense)

	return &expense, result.Error
}

func FindExpenses(DB *gorm.DB, args model.ExpensesArgs) ([]*model.Expense, error) {
	var expenses []*model.Expense
	var result *gorm.DB

	//todo implement type and sortBy
	if args.By == model.ExpensesByStore {
		result = DB.Where(&model.Product{StoreID: args.Value}).Order("id DESC").Offset(args.Offset).Limit(args.Limit).Find(&expenses)
	} else if args.By == model.ExpensesByStaff {
		panic(fmt.Errorf("not implemented"))
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	return expenses, result.Error
}
