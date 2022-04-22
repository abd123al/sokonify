package util

import (
	"github.com/glebarez/sqlite"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

type InitDbArgs struct {
	DbName  string
	Clear   bool
	Offline bool
	Mobile  bool
}

func InitDB(args InitDbArgs) (DB *gorm.DB) {
	var db *gorm.DB
	var err error

	// We are using sqlite in offline mobile apps
	if args.Offline && args.Mobile {
		db, err = gorm.Open(sqlite.Open(":memory:?_pragma=foreign_keys(1)"), &gorm.Config{})
	} else {
		dsn := "host=localhost user=postgres password=password dbname=" + args.DbName + " port=5432 sslmode=disable TimeZone=Africa/Nairobi"
		db, err = gorm.Open(postgres.New(postgres.Config{DSN: dsn}), &gorm.Config{
			//Logger: logger.Default.LogMode(logger.Info),
		})
	}

	if err != nil {
		panic("failed to connect database")
	}

	// todo: Check if this is not production
	if args.Clear {
		if args.Offline {
			// Clearing sqlite
			//todo
		} else {
			//Clearing postgres.
			db.Exec("" +
				"DROP SCHEMA public CASCADE; " +
				"CREATE SCHEMA public; " +
				"GRANT ALL ON SCHEMA public TO postgres; " +
				"GRANT ALL ON SCHEMA public TO public;" +
				"")
		}
	}

	err = db.AutoMigrate(
		&model.Admin{}, &model.CategoryProduct{}, &model.Customer{}, &model.Staff{}, &model.Item{}, &model.Store{}, &model.Order{}, model.OrderItem{},
		&model.User{}, &model.Payment{}, &model.Ledger{}, &model.Product{}, &model.Brand{},
	)
	if err != nil {
		panic("failed to auto migrate")
	}

	return db
}
