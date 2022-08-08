package repository_test

import (
	"fmt"
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestItem(t *testing.T) {
	DB := util.InitTestDB()
	product := util.CreateProduct(DB, nil)
	unit := util.CreateUnit(DB, product.StoreID, nil)
	cat := util.CreateCategory(DB, *product.StoreID, model.CategoryTypeSubcategory)
	priceCategory := util.CreateCategory(DB, *product.StoreID, model.CategoryTypePricing)
	priceCategory2 := util.CreateCategory(DB, *product.StoreID, model.CategoryTypePricing)

	t.Run("CreateItem", func(t *testing.T) {
		item, _ := repository.CreateItem(DB, model.ItemInput{
			ProductID:   product.ID,
			UnitID:      unit.ID,
			Quantity:    12,
			BuyingPrice: "2000",
			Categories:  []int{cat.ID},
			Prices: []*model.PriceInput{
				{Amount: "5000.00", CategoryID: priceCategory.ID},
				{Amount: "10000.00", CategoryID: priceCategory2.ID},
			},
		}, *product.CreatorID)

		require.GreaterOrEqual(t, item.ID, 1)

		//Test finding its categories
		res, err := repository.FindProductCategories(DB, model.CategoryTypeSubcategory, item.ID)
		require.Nil(t, err)
		require.GreaterOrEqual(t, len(res), 1)
	})

	var create = func() *model.Item {
		i, _ := repository.CreateItem(DB, model.ItemInput{
			Quantity:    10,
			BuyingPrice: "1000",
			UnitID:      unit.ID,
			ProductID:   product.ID,
			Prices: []*model.PriceInput{
				{Amount: "5000.00", CategoryID: priceCategory.ID},
				{Amount: "10000.00", CategoryID: priceCategory2.ID},
			},
		}, *product.CreatorID)

		return i
	}

	t.Run("EditItem", func(t *testing.T) {
		i := create()

		item, err := repository.EditItem(DB, i.ID, model.ItemInput{
			UnitID:      unit.ID,
			Quantity:    12,
			BuyingPrice: "2000",
			Batch:       nil,
			Description: nil,
			ExpiresAt:   nil,
			BrandID:     nil,
			Prices: []*model.PriceInput{
				{Amount: "8000.00", CategoryID: priceCategory.ID},
				{Amount: "16000.00", CategoryID: priceCategory2.ID},
			},
			ProductID: product.ID,
		}, *i.CreatorID)

		require.Nil(t, err)
		require.NotNil(t, item)
	})

	t.Run("FindItems by store", func(t *testing.T) {
		create()

		items, err := repository.FindItems(DB, model.ItemsArgs{
			By: model.ItemsByStore,
		}, *product.StoreID)

		for i := 0; i < len(items); i++ {
			fmt.Println(items[i].ID)
			require.NotEqual(t, items[i].ID, 0)
		}

		require.Nil(t, err)
		require.NotEmpty(t, items)
	})

	t.Run("FindItems by product", func(t *testing.T) {
		create()

		items, _ := repository.FindItems(DB, model.ItemsArgs{
			By:    model.ItemsByProduct,
			Value: product.ID,
		}, *product.StoreID)

		require.NotEmpty(t, items)
	})

	t.Run("SumItemsCost", func(t *testing.T) {
		create()

		itemsStat, _ := repository.SumItemsCost(DB, *product.StoreID)

		println("TotalCost %v", itemsStat[0].TotalCost)
		println("ExpectedProfit %v", itemsStat[0].ExpectedProfit)
		println("TotalReturn %v", itemsStat[0].TotalReturn)
		println("CategoryID %v", itemsStat[0].CategoryID)

		//require.NotEmpty(t, itemsStat.ExpectedProfit)
		//require.NotEmpty(t, itemsStat.TotalCost)
		//require.NotEmpty(t, itemsStat.TotalReturn)
	})
}
