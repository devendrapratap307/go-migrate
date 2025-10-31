DB_URL=postgres://admin:Admin@123@localhost:5432/go_migrate_db?sslmode=disable
MIGRATIONS_PATH=db/migrations

run:
	go run cmd/main.go

migrate-up:
	migrate -path $(MIGRATIONS_PATH) -database "$(DB_URL)" up

migrate-down:
	migrate -path $(MIGRATIONS_PATH) -database "$(DB_URL)" down

migrate-new:
	migrate create -ext sql -dir $(MIGRATIONS_PATH) -seq $(name)
