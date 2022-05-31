package util

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"mahesabu/graph/model"
)

type InitDbArgs struct {
	DbName    string
	Clear     bool
	IsServer  bool
	Dsn       string
	IsRelease bool
}

func InitDB(args InitDbArgs) (DB *gorm.DB) {
	var db *gorm.DB
	var err error
	dbName := args.DbName

	// We are using sqlite in offline mobile apps
	if args.IsServer {
		password := "password"
		port := "5432"

		//These will be used for enterprise edition
		if args.IsRelease {
			password = "#$0k0n1fy@5433"
			port = "5433"
			dbName = "sokonify"
		}
		dsn := fmt.Sprintf("host=localhost user=postgres password=%s dbname=%s port=%s sslmode=disable TimeZone=Africa/Nairobi", password, dbName, port)
		db, err = gorm.Open(postgres.New(postgres.Config{DSN: dsn}), &gorm.Config{
			//Logger: logger.Default.LogMode(logger.Info),
		})
	} else {
		dsn := "sokonify.db"
		if args.Dsn != "" {
			//In android, we need full path
			dsn = args.Dsn
		}
		db, err = gorm.Open(sqlite.Open(dsn), &gorm.Config{})
	}

	if err != nil {
		panic(fmt.Sprintf("failed to connect database with error: %s", err.Error()))
	}

	if args.Clear && !args.IsRelease {
		if args.IsServer {
			//Clearing postgres.
			db.Exec("" +
				"DROP SCHEMA public CASCADE; " +
				"CREATE SCHEMA public; " +
				"GRANT ALL ON SCHEMA public TO postgres; " +
				"GRANT ALL ON SCHEMA public TO public;" +
				"")
		} else {
			// Clearing sqlite
			//todo
		}
	}

	if err = db.AutoMigrate(
		&model.Admin{}, &model.Customer{}, &model.Expense{}, &model.Staff{}, &model.Item{}, &model.Store{}, &model.Order{}, model.OrderItem{},
		&model.User{}, &model.Payment{}, &model.Product{}, &model.ProductCategory{}, &model.Brand{}, &model.Unit{},
	); err != nil {
		panic(fmt.Sprintf("failed to auto migrate with error: %s", err.Error()))
	}

	return db
}

func InitTestDB() *gorm.DB {
	DB := InitDB(InitDbArgs{
		DbName:   "mahesabu_test",
		Clear:    true,
		IsServer: true,
	})

	return DB
}
