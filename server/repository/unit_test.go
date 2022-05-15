package repository_test

import (
	"github.com/stretchr/testify/require"
	"mahesabu/graph/model"
	"mahesabu/repository"
	"mahesabu/util"
	"testing"
)

func TestUnits(t *testing.T) {
	DB := util.InitTestDB()
	user := util.CreateUser(DB)
	store := util.CreateStore(DB, &user.ID)

	t.Run("CreateUnit", func(t *testing.T) {
		template := model.TemplateTypePharmacy

		unit, _ := repository.CreateUnit(DB, model.UnitInput{
			Name:         "Tablets",
			TemplateType: &template,
		}, repository.CreateUnitsArgs{
			StoreID: &store.ID,
			UserID:  &user.ID,
		})

		require.NotNil(t, unit)
	})

	t.Run("FindUnits", func(t *testing.T) {
		util.CreateUnit(DB, &store.ID, nil)

		units, _ := repository.FindUnits(DB, store.ID)
		require.NotEmpty(t, units)
	})

	t.Run("FindUnit", func(t *testing.T) {
		unit, _ := repository.FindUnit(DB, util.CreateUnit(DB, &store.ID, nil).ID)
		require.NotNil(t, unit)
	})
}
