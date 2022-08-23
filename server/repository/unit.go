package repository

import (
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

type CreateUnitsArgs struct {
	StoreID *int
	UserID  *int
}

func CreateUnit(db *gorm.DB, input model.UnitInput, Args CreateUnitsArgs) (*model.Unit, error) {
	unit := model.Unit{
		Name:         input.Name,
		TemplateType: input.TemplateType,
		StoreID:      Args.StoreID,
		UserID:       Args.UserID,
	}
	result := db.Create(&unit)
	return &unit, result.Error
}

func EditUnit(db *gorm.DB, ID int, input model.UnitInput, Args CreateUnitsArgs) (*model.Unit, error) {
	Unit := model.Unit{
		Name:         input.Name,
		TemplateType: input.TemplateType,
		StoreID:      Args.StoreID,
		UserID:       Args.UserID,
	}

	if err := db.Model(&Unit).Where(&model.Unit{ID: ID}).Updates(&Unit).Error; err != nil {
		return nil, err
	}

	return &Unit, nil
}

func FindUnits(db *gorm.DB, StoreID int) ([]*model.Unit, error) {
	var units []*model.Unit
	//todo we should get units by template
	result := db.Where(&model.Unit{StoreID: &StoreID}).Find(&units)
	return units, result.Error
}

func FindUnit(db *gorm.DB, ID int) (*model.Unit, error) {
	var unit *model.Unit
	result := db.Where(&model.Unit{ID: ID}).Find(&unit)
	return unit, result.Error
}
