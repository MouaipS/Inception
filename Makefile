all: up

up: 
	@sudo mkdir -p /home/adrouin/data
	@sudo mkdir -p /home/adrouin/data/mariadb
	@sudo mkdir -p /home/adrouin/data/wordpress
	@sudo mkdir -p /home/adrouin/data/redis
	@sudo docker compose -f ./srcs/docker-compose.yml up -d

down:
	@sudo docker compose -f ./srcs/docker-compose.yml down

clean: down
	@sudo rm -rf /home/adrouin/data

fclean: clean
	@sudo docker system prune -af

re: fclean all

.PHONY:
	all up down clean fclean re 
