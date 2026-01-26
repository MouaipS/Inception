*This project has been created as part of the 42 curriculum by adrouin.*

# Inception

## Description
The goal of this project is to deploy a secure, containerized web infrastructure using Docker and Docker Compose.                       
Inception is a system administration project focus on Docker containerization. The project involves setting up a small infrastructure composed of multiple services running in Docker containers.   
The mandatory part requires 3 services: 
- MariaDB
- Nginx
- WordPress

The bonus part requires to add additional service, always in specific Docker.
- Redis
- FTP Server
- a static website
- Adminer
- A service of our choice : I choose Portainer

There are some specifications like where the volume is, how they are connected, which images we can use...

## Instructions

If you want to run the whole project or a specific service, I recommend you to follow the user.md or the developper.md. It will provide you all stuff to know how to build your own Inception project structure. You can find them in the repo.

If you really want to have a commands in this readme without knowing how it works, try :
```bash
make
```

## Project Description (Additionnal part)

### VM vs Docker

A virtual machine is a secure work environment. It works thanks to a hypervisor (program that will pretend to be in a physical machine). The OS communicates with the hypervisor who will perform the actions. Here we are on a type 2 VM: VirtualBox (application installed on the host operating system). It is a hosted hypervisor. As the VMs carry a complete operating system for each instance, this leads to a significant loss of resources. In contrast, they have a very strong isolation.

A docker is smaller than a VM. Initially, docker is a technology of the Linux kernel (Cgroup). The principle is that a docker application runs in a cgroup and sees nothing outside of this cgroup. The app communicates directly with the kernel, no intermediary like the VM. This makes the containers lighter, faster to start, and more efficient in terms of resources. Security is weaker than a VM but it’s very rare. 
To launch containers, we use runtimes. The most well-known is Docker.

### Secrets vs Environment Variables

Environment variables are simple to use to set up an application, but they are not ideal for storing sensitive information because they can be exposed unintentionally (logs, commands).

Docker Secrets are designed specifically for managing sensitive data (passwords, API keys, certificates). They offer a better level of security by limiting access to secrets only to the services that need them.

### Docker Network vs Host Network

A Docker Network creates an isolated network in which containers can communicate with each other in a secure and controlled manner. It improves project isolation, portability and security. Host Network removes this layer of isolation by allowing the container to directly use the host machine’s network. Although more efficient in some cases, it reduces security and flexibility.

### Docker Volumes vs Bind Mounts

Docker Volumes are managed directly by Docker. It is technically the recommended solution for data persistence as they are independent of the host file system structure and facilitate backup and portability. They are technically more secure than the Bind Mounts because they are more isolated from the host. 

Bind Mounts directly link a directory from the host system to a container. They are useful in the development phase for direct access to files, but make the project more dependent on the host environment and less portable. 

## Resources

### General ressources 

You can try to find some guides to help you. I don't recommend you to follow them, try first to do everything and if you can't pass the wall, use them to find how to pass through. 

### Docker
https://docs.docker.com/ : Perfect for understanding the installation of Docker on your machine and the writing of Dockerfile/Docker-compose.

### Nginx
https://nginx.org/en/docs/beginners_guide.html : Same for Nginx

https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/ : Little more for the configuration file

### Mariadb
https://mariadb.com/docs/server/mariadb-quickstart-guides/installing-mariadb-server-guide && https://docs.rockylinux.org/10/ko/books/web_services/041-database-servers-mariadb : Installation and comprehension of mysql

### WordPress

https://stephane-arrami.com/articles/guide-pratique-pour-dockeriser-wordpress-avec-un-dockerfile-personnalise/ : Answer a good number of technical questions. Otherwise, cross many sources and forums.

## AI Usage

Claude.ai was used to have tracks and debuggage when it wasn’t obvious. He helped me a lot to see errors of inattention like bad syntax.

## Author

Login : Adrouin : https://github.com/MouaipS
