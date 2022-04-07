package util

import (
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

type InitDbArgs struct {
	DbName  string
	Clear   bool
	Offline bool
}

func InitDB(args InitDbArgs) (DB *gorm.DB) {
	dsn := "host=localhost user=postgres password=password dbname=" + args.DbName + " port=5432 sslmode=disable TimeZone=Africa/Nairobi"
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn}))
	if err != nil {
		panic("failed to connect database")
	}

	// todo: Check if this is not production
	if args.Clear {
		//Clearing db.
		db.Exec("" +
			"DROP SCHEMA public CASCADE; " +
			"CREATE SCHEMA public; " +
			"GRANT ALL ON SCHEMA public TO postgres; " +
			"GRANT ALL ON SCHEMA public TO public;" +
			"")
	}

	err = db.AutoMigrate(
		&model.Staff{}, &model.Item{}, &model.Store{}, &model.Order{}, model.OrderItem{},
		&model.User{}, &model.Payment{}, &model.Ledger{}, &model.Product{}, &model.Brand{},
	)
	if err != nil {
		panic("failed to auto migrate")
	}

	return db
}
