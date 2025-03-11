citext_dev:
	docker exec -it postgres psql -U postgres -d svot_dev -c "CREATE EXTENSION citext;"
citext_test:
	docker exec -it postgres psql -U postgres -d svot_test -c "CREATE EXTENSION citext;"
