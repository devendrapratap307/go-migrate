# Golang Migrate Project

This project demonstrates how to use **golang-migrate** for managing database migrations in a Go project.

---

## 🚀 Features
- PostgreSQL database integration
- Database migrations using [golang-migrate](https://github.com/golang-migrate/migrate)
- Environment-based configuration (local, dev, prod)
- Simple Go application using GORM
- Docker setup for PostgreSQL

---

## 🧰 Requirements
- Go 1.20+
- PostgreSQL 14+
- [golang-migrate CLI](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)
- Docker (optional)

---

## 🧩 Project Structure
```
.
├── cmd/
│   └── main.go           # Main application entry point
├── db/
│   ├── migrations/       # Migration SQL files
│   └── db.go             # Database connection setup
├── models/
│   └── product.go        # Example GORM model
├── .env                  # Environment variables
├── go.mod
├── go.sum
└── README.md
```

---

## ⚙️ Setup

### 1. Install Dependencies
```bash
go mod tidy
```

### 2. Setup PostgreSQL (using Docker)
```bash
docker run --name pg-migrate -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=appdb -p 5432:5432 -d postgres:14
```

### 3. Create `.env` file
```bash
DB_DSN=postgres://admin:admin@localhost:5432/appdb?sslmode=disable
```

---

## 🏗 Create and Run Migrations

### Create Migration Files
```bash
migrate create -ext sql -dir db/migrations -seq create_products_table
```

This creates two files like:
```
db/migrations/
  000001_create_products_table.up.sql
  000001_create_products_table.down.sql
```

### Example Migration
**000001_create_products_table.up.sql**
```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**000001_create_products_table.down.sql**
```sql
DROP TABLE IF EXISTS products;
```

---

### Run Migrations
```bash
migrate -path db/migrations -database "$DB_DSN" up
```

To roll back:
```bash
migrate -path db/migrations -database "$DB_DSN" down 1
```

---

## 🧠 Example Go Code (`cmd/main.go`)
```go
package main

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Product struct {
	ID   uint   `gorm:"primaryKey"`
	Name string
	Price float64
}

func main() {
	dsn := os.Getenv("DB_DSN")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect database: %v", err)
	}

	fmt.Println("✅ Database connected successfully!")
}
```

---

## 🧾 Useful Commands

| Command | Description |
|----------|-------------|
| `migrate create -ext sql -dir db/migrations -seq name` | Create a new migration file |
| `migrate -path db/migrations -database "$DB_DSN" up` | Apply all migrations |
| `migrate -path db/migrations -database "$DB_DSN" down` | Roll back migrations |
| `migrate force VERSION` | Force version in case of failed migration |

---

## Run Everything
```bash
make migrate-up
make run
```

---

## Step 1 :Create a new migration
### Run this command in your project directory (same place as go.mod):
```bash
migrate create -ext sql -dir db/migrations add_quantity_to_products
```
### or

```bash
make migrate-new name=add_quantity_to_products
```
### This will generate two files like:
```bash
db/migrations/
├── 0001_create_products_table.up.sql
├── 0001_create_products_table.down.sql
├── 0002_add_quantity_to_products.up.sql
├── 0002_add_quantity_to_products.down.sql

```

## Step 2: Write SQL inside migration files
### ✅ 0002_add_quantity_to_products.up.sql
```bash
ALTER TABLE products
ADD COLUMN quantity INT DEFAULT 0;
```

### 🔁 0002_add_quantity_to_products.down.sql
```bash
ALTER TABLE products
DROP COLUMN IF EXISTS quantity;
```
## Step 3: Run migration
### Then,
### Now apply the migration:
```bash
migrate -path db/migrations -database "postgres://user:password@localhost:5432/your_db?sslmode=disable" up
```
### Or by Makefile,
```bash
make migrate-up
```


## 🧹 Cleanup
```bash
docker stop pg-migrate && docker rm pg-migrate
```

---

## 📘 References
- [golang-migrate Documentation](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)
- [GORM Official Docs](https://gorm.io/docs/)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)

---

### 🧑‍💻 Author
**Devendra Pratap**  
Go Developer | Microservices | PostgreSQL | Docker | REST