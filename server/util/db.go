package util

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"mahesabu/repository"
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
		&model.User{}, &model.Payment{}, &model.Price{}, &model.Product{}, &model.ProductCategory{}, &model.Brand{}, &model.Unit{},
	); err != nil {
		panic(fmt.Sprintf("failed to auto migrate with error: %s", err.Error()))
	}

	if (db.Migrator().HasColumn(&model.Item{}, "selling_price")) {
		err = db.Transaction(func(tx *gorm.DB) error {
			var stores []*model.Store

			if err = tx.Find(&stores).Error; err != nil {
				log.Printf("error in finding stores %e", err)
				return err
			}

			for _, s := range stores {
				type ItemResult struct {
					ID           int    `json:"id" gorm:"primaryKey"`
					SellingPrice string `json:"sellingPrice" gorm:"type:numeric;not null;unsigned"`
				}

				var items []*ItemResult

				err := tx.Table("items").Joins("inner join products on products.id = items.product_id AND products.store_id = ?", s.ID).Scan(&items).Error

				if err != nil {
					log.Printf("error in finding items %e", err)
					return err
				}

				cat, err := repository.CreateCategory(tx, model.CategoryInput{
					Name: "Pricing",
					Type: model.CategoryTypePricing,
				}, helpers.UserAndStoreArgs{
					UserID:  s.UserID,
					StoreID: s.ID,
				})

				var prices []*model.Price

				for _, i := range items {
					p, err := repository.CreatePrice(tx, i.ID, model.PriceInput{
						Amount:     i.SellingPrice,
						CategoryID: cat.ID,
					}, helpers.UserAndStoreArgs{
						UserID:  s.UserID,
						StoreID: s.ID,
					})

					if err != nil {
						log.Printf("error in creating price for item %d %e", i.ID, err)
						return err
					}

					prices = append(prices, p)
				}
			}

			//if len(prices) > 0 && len(items) > 0 {
			//err := tx.Migrator().DropColumn(&model.Item{}, "selling_price")
			//if err != nil {
			//	log.Printf("error in dropping selling price column %e", err)
			//}
			//}

			return nil
		})

		if err != nil {
			log.Printf("Migration failed %e", err)
		}
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
