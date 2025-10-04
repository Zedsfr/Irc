all : up 

up :
	mkdir -p ~/mdiomand/data/mariadb
	mkdir -p ~/mdiomand/data/wordpress
	docker compose -f srcs/docker-compose.yml up --build

down : 
	docker compose -f srcs/docker-compose.yml down

delete :
	sudo rm -rf ~/mdiomand/data/*

clean : delete
	docker container prune -f
	docker system prune -af
	docker volume rm -f srcs_mariadb
	docker volume rm -f srcs_wordpress

log :
	docker compose -f srcs logs

re : clean all