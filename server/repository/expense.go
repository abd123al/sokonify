package repository

import (
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

//func FindExpenses(DB *gorm.DB, by model.ProductsBy, value int) ([]*model.Expense, error) {
//	var items []*model.Product
//	var result *gorm.DB
//
//	if by == model.ProductsByStore {
//		result = DB.Table("products").Where(&model.Product{StoreID: value}).Find(&items)
//	} else if by == model.ProductsByCategory {
//		result = DB.Table("products").Joins("inner join product_categories on product_categories.product_id = products.id AND product_categories.category_id = ?", value).Find(&items)
//	} else {
//		panic(fmt.Errorf("not implemented"))
//	}
//
//	return items, result.Error
//}
