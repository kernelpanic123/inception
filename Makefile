all:
	mkdir -p /home/abder/data/mariadb
	mkdir -p /home/abder/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -a
	rm -rf /home/abder/data/mariadb/*
	rm -rf /home/abder/data/wordpress/*

.PHONY: all down clean
