all:
	mkdir -p /home/lonelyfish/data/mariadb
	mkdir -p /home/lonelyfish/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -a
	sudo rm -rf /home/lonelyfish/data/mariadb/*
	sudo rm -rf /home/lonelyfish/data/wordpress/*

.PHONY: all down clean
