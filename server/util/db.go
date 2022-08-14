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
	"time"
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

	sqlDB, err1 := db.DB()

	if err1 != nil {
		panic(fmt.Sprintf("failed to connect database with error: %s", err1.Error()))
	}

	// SetMaxIdleConns sets the maximum number of connections in the idle connection pool.
	sqlDB.SetMaxIdleConns(10)

	// SetMaxOpenConns sets the maximum number of open connections to the database.
	sqlDB.SetMaxOpenConns(100)

	// SetConnMaxLifetime sets the maximum amount of time a connection may be reused.
	sqlDB.SetConnMaxLifetime(time.Hour)

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
		&model.Admin{},
		&model.Customer{},
		&model.Expense{},
		&model.Staff{},
		&model.Item{},
		&model.Store{},
		&model.Order{},
		&model.OrderItem{},
		&model.User{},
		&model.Payment{},
		&model.Price{},
		&model.Product{},
		&model.ProductCategory{},
		&model.Brand{},
		&model.Unit{},
		&model.Permission{},
	); err != nil {
		panic(fmt.Sprintf("failed to auto migrate with error: %s", err.Error()))
	}

	if (db.Migrator().HasColumn(&model.Item{}, "selling_price")) {
		err = db.Transaction(func(tx *gorm.DB) error {
			var stores []*model.Store

			if err = tx.Find(&stores).Error; err != nil {
				return fmt.Errorf("error in finding stores %e", err)
			}

			log.Printf("stores found: %d\n", len(stores))

			for _, s := range stores {
				log.Printf("current store: %d\n", s.ID)

				type ItemResult struct {
					ID           int    `json:"id" gorm:"primaryKey"`
					SellingPrice string `json:"sellingPrice" gorm:"type:numeric;not null;unsigned"`
				}

				var items []*ItemResult

				err := tx.Table("items").Select("items.selling_price, items.id").Joins("inner join products on products.id = items.product_id AND products.store_id = ?", s.ID).Scan(&items).Error

				log.Printf("items found: %v\n", items)

				if err != nil {
					return fmt.Errorf("error in finding items %e", err)
				}

				cat, err := repository.CreateCategory(tx, model.CategoryInput{
					Name: "Pricing",
					Type: model.CategoryTypePricing,
				}, helpers.UserAndStoreArgs{
					UserID:  s.UserID,
					StoreID: s.ID,
				})

				if err != nil {
					return fmt.Errorf("error in create category %e", err)
				}

				log.Printf("category created: %d\n", cat.ID)

				var prices []*model.Price

				for _, item := range items {
					log.Printf("current item: %d\n", item.ID)

					p, err := repository.CreatePrice(tx, item.ID, model.PriceInput{
						Amount:     item.SellingPrice,
						CategoryID: cat.ID,
					}, helpers.UserAndStoreArgs{
						UserID:  s.UserID,
						StoreID: s.ID,
					})

					if err != nil {
						return fmt.Errorf("error in creating price for item %d %e", item.ID, err)
					}

					log.Printf("price created: %d\n", p.ID)

					prices = append(prices, p)
				}
			}

			var count int64

			if err := tx.Model(&model.Price{}).Count(&count).Error; err != nil {
				return fmt.Errorf("error counting prices %e", err)
			}

			log.Printf("Prices were inserted: %d\n", count)

			if count > 0 {
				err = tx.Migrator().DropColumn(&model.Item{}, "selling_price")
			} else {
				return fmt.Errorf("no new prices were insrted")
			}

			if err != nil {
				return fmt.Errorf("error in dropping selling price column %e", err)
			}

			return nil
		})

		if err != nil {
			log.Printf("Migration failed with error: %e", err)
		}
	}

	if (db.Migrator().HasColumn(&model.Staff{}, "store_id")) {
		err = db.Transaction(func(tx *gorm.DB) error {
			err := tx.Migrator().DropConstraint(model.Permission{}, "fk_permissions_role")
			if err != nil {
				return fmt.Errorf("error in DropConstraint Permission %e", err)
			}

			err = tx.Migrator().DropConstraint(model.Staff{}, "fk_staffs_role")
			if err != nil {
				return fmt.Errorf("error in DropConstraint Staff %e", err)
			}

			var stores []*model.Store

			if err = tx.Find(&stores).Error; err != nil {
				return fmt.Errorf("error in finding stores %e", err)
			}

			log.Printf("stores found: %d\n", len(stores))

			for _, s := range stores {
				log.Printf("current store: %d\n", s.ID)

				role, err := repository.CreateCategory(tx, model.CategoryInput{
					Name:            "Owners",
					Type:            model.CategoryTypeRole,
					PermissionTypes: []model.PermissionType{model.PermissionTypeAll},
				}, helpers.UserAndStoreArgs{
					UserID:  s.UserID,
					StoreID: s.ID,
				})

				if err != nil {
					return fmt.Errorf("error in create role %e", err)
				}

				log.Printf("role created: %d\n", role.ID)

				var staffs []*model.Staff
				err2 := tx.Table("staffs").Where("staffs.store_id = ?", s.ID).Find(&staffs).Error

				if err2 != nil {
					return fmt.Errorf("error in create role %e", err)
				}

				for _, staff := range staffs {
					tx.Model(&model.Staff{}).Where(&model.Staff{ID: staff.ID}).Update("role_id", role.ID)
				}
			}

			err1 := tx.Migrator().DropColumn(&model.Staff{}, "store_id")
			if err1 != nil {
				return fmt.Errorf("error in drop store_id %e", err1)
			}

			err1 = tx.Migrator().DropColumn(&model.Staff{}, "role")
			if err1 != nil {
				return fmt.Errorf("error in drop role %e", err1)
			}

			return nil
		})

		if err != nil {
			log.Printf("Staff Migration failed with error: %e", err)
		}
	}

	if (db.Migrator().HasColumn(&model.Staff{}, "default")) {
		err = db.Transaction(func(tx *gorm.DB) error {
			tx.Model(&model.Staff{}).Where("default", true).Update("preferred", model.BoolTypeYes)

			err1 := tx.Migrator().DropColumn(&model.Staff{}, "default")
			if err1 != nil {
				return fmt.Errorf("error in drop role %e", err1)
			}

			return nil
		})

		if err != nil {
			log.Printf("Staff default Migration failed with error: %e", err)
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
