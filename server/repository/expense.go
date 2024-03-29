package repository

import (
	"fmt"
	"gorm.io/gorm"
	"mahesabu/graph/model"
	"mahesabu/helpers"
)

func CreateExpense(DB *gorm.DB, input model.ExpenseInput, args helpers.UserAndStoreArgs) (*model.Expense, error) {
	expense := model.Expense{
		Name:      input.Name,
		Type:      input.Type,
		StoreID:   args.StoreID,
		CreatorID: &args.UserID,
	}

	result := DB.Create(&expense)

	return &expense, result.Error
}

func FindExpenses(DB *gorm.DB, args model.ExpensesArgs, StoreID int) ([]*model.Expense, error) {
	var expenses []*model.Expense
	var result *gorm.DB

	//todo implement type and sortBy
	if args.By == model.ExpensesByStore {
		result = DB.Where(&model.Expense{StoreID: StoreID}).Order("id DESC").Find(&expenses)
	} else if args.By == model.ExpensesByStaff {
		panic(fmt.Errorf("not implemented"))
	} else {
		panic(fmt.Errorf("not implemented"))
	}

	return expenses, result.Error
}

func FindExpense(db *gorm.DB, ID int) (*model.Expense, error) {
	var expense *model.Expense
	result := db.Where(&model.Expense{ID: ID}).First(&expense)
	return expense, result.Error
}
