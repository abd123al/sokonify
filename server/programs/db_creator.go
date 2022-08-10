package main

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

import (
	"log"
)

func main() {
	createPgDb()
}

func createPgDb() {
	port := "5433"
	password := "#$0k0n1fy@5433"

	dsn := fmt.Sprintf("host=localhost user=postgres password=%s port=%s sslmode=disable TimeZone=Africa/Nairobi", password, port)
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn}))

	if err != nil {
		log.Printf("Failed to connect to database: %s\n", err.Error())
	}

	db.Debug().Exec("CREATE DATABASE sokonify;")
	db.Debug().Exec("SELECT datname FROM pg_database WHERE datistemplate = false;")

	_, _ = fmt.Scanln()
	fmt.Println("done")
}
