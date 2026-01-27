# Developper documentation

Welcome here, in the Developper Documentation.
The goal of this documentation will be answer the following questions :

- How to set up the environment from scratch ?
- How to build and launch the project using the Makefile and Docker Compose ?
- What are the orders to manage the containers and volumes ?
- where the project data is stored and how it persists ?

Let's start !!

## How to set up the environment from scratch ?

The first step to set up the environment is to set your user into the sudo group :
```bash
sudo usermod -aG sudo <username>
```

Then, you need to install Docker Engine. You can also install Docker Hub (forbiden in Inception). For that you need to follow [Docker installation guide](https://docs.docker.com/engine/install).

If you have some probleme, try to add your user into docker group.
```bash
sudo groupadd docker
&&
sudo usermod -aG docker <username>
```

## How to build and launch the project using the Makefile and Docker Compose ?

To build the dockers, the volumes and run: ``make`>

To stop the docker runnings : ``make down```<

To stop the docker runnings and destroy the volumes: ```make clean``>

To stop and delete all the images and destroy the volumes: ```make fclean`>

These commands use the commands of the docker composer. Therefore, one can directly use these commands. To enter a particular docker:
```
docker exec -it <docker_name> arg -p (password if needed)
```
## What are the orders to manage the containers and volumes ?

Stop services (without removing)
```
docker compose stop
```

Restart the services
```
docker compose restart
```

Stop and delete the containers + networks
```
docker compose down
```

Stop and delete containers + networks + volumes
ATTENTION: deletes all persistent data
```
docker compose down -v
```

See the status of the containers
```
docker ps
```

See the status of project services
```
docker compose ps
```

See the logs of all services:
```
docker compose logs
```

List the volumes
```
docker volume ls
```

## Where the project data is stored and how it persists ?

All volumes will be stored: `/home/login/data`. It's persistent because when we restart, volumes aren't deleted.





