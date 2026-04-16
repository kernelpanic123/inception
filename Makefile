all:
	#mkdir -p /Users/abder/data/mariadb
	#mkdir -p /Users/abder/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml up --build

down:
	docker-compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -a
	rm -rf /home/${USER}/data/mariadb/*
	rm -rf /home/${USER}/data/wordpress/*

.PHONY: all down clean