# User documentation

Welcome here, in the User Documentation.
The goal of this documentation will be answer the following questions :

- What services are provided by the stack ?
- How can we start/stop the project ?
- How can we access to the website and the administration panel ?
- Where can we found all manage credentials ?
- How can i verify if the services is running correctly ?

Let's start !!

## What services are provided by the stack ?

In the mandatory part, we have 3 services that fit together in this way:
```
NGINX (Port 443)
   ↓ FastCGI
PHP-FPM (Port 9000)   #Runs WordPress
   ↓ MySQL Protocol
MariaDB (Port 3306)
```

### NGINX

The first services is Nginx, a web server with TLS Protocol (TLSv1.2/TLSv1.3). His role in Inception is that of a reverse proxy: he receives users' https requests and forwards them to the wordpress services. He then returns the responses to the client. He is the only docker related to the 'outside world' via the port **443** (which corresponds to https).

It also manages TLS (Transport Layer Security) encryption, a security protocol that allows the encryption of communications between a client and a server. It has the SSL certificate that allows our site to be in https and not http. 

It communicates with WordPress via the FastCGI protocle (useful for dynamic pages). Dynamic files are managed in PHP-FPM (the FastCGI manager), while static site files are directly in the volumes.

The service is presented as follows in the repo:
```
requirements/nginx/
├── Dockerfile          # building the image
├── conf/
│   └── nginx.conf      # Nginx configuration
└── tools/
    └── setup.sh        # configuration script
```

### WORDPRESS

The second service is Wordpress. It’s a CMS, a Content Management System. It allows you to create and manage a dynamic website. WordPress processes all the dynamic requests transmitted by NGINX. It is written in PHP. It communicates only with Nginx on the port **9000** and with Mariadb on the **3306**.

It has a persistent volume at `>/var/www/html`. This volume has been mapped to `>/home/login/data/wordpress`.

The service is presented as follows in the repo:
```
requirements/wordpress/
├── Dockerfile          # building the image
├── conf/
│   └── www.conf        # Wordpress configuration
└── tools/
    └── script.sh       # configuration script
```
### MARIADB

MariaDB is the relational database management system of the infrastructure. It stores all the persistent data of WordPress: articles, pages, users, comments, settings, etc. It is the essential storage backend for the proper functioning of the site. We use Mariadb because it is an open-source fork of MySQL created in 2009. It is compatible with MySQL (same protocol, same SQL syntax)

The service is presented as follows in the repo:
```
requirements/mariadb/
├── Dockerfile          
├── conf/
│   └── 50-server.conf  
└── tools/
    └── entrypoint.sh   
    └──init.sql.template
```

### REDIS
Redis is an in-memory cache system that improves the performance of WordPress. It stores in RAM the results of complex MySQL queries made by WordPress. When a user requests a page for the first time, WordPress queries MariaDB. Redis then caches the result of this query. When another user requests the same page, Redis provides data directly from RAM, without querying MariaDB. This significantly reduces the loading time of pages and the load on the database.

Redis communicates with WordPress on port **6379** (Redis standard port). It requires the installation of the "Redis Object Cache" plugin in WordPress to work. The configuration is done via the constants `WP_REDIS_HOST` and `WP_REDIS_PORT` in the `wp-config.php`file.

The service is presented as follows in the repo:
```
requirements/bonus/redis/
├── Dockerfile          
├── conf/
│   └── redis.conf      
└── tools/
    └── script.sh       
```

### FTP SERVER
The FTP (File Transfer Protocol) server allows you to transfer files to and from the WordPress site via an FTP client. It points directly to the WordPress volume (`/var/www/html`), thus allowing you to download, upload or modify site files (themes, plugins, media) without going through the WordPress interface.

The server uses **vsftpd** (Very Secure FTP Daemon), a secure FTP server for Linux. It listens on port **21** (standard FTP port) and also uses passive ports (usually 21100-21110) for data transfers.

FTP users must be configured with credentials (username and password) stored in environment variables. The FTP server shares the same volume as WordPress for direct access to site files.

The service is presented as follows in the repo:
```
requirements/bonus/ftp/
├── Dockerfile          
├── conf/
│   └── vsftpd.conf     
└── tools/
    └── setup.sh       
```

### STATIC SITE
The static site is a simple website created in a language other than PHP (HTML/CSS). It can serve as a showcase, a portfolio, or a presentation page. Unlike WordPress which generates dynamic content, this site serves pre-generated static pages.

The static site has its own container with a web server (NGINX) to serve HTML, CSS files. He is listening on a different port **8081**.

This service demonstrates the flexibility of Docker: several web services can coexist in the same infrastructure, each in its isolated container.

The service is presented as follows in the repo:
```
requirements/bonus/static-site/
├── Dockerfile          
├── conf/               
    ├── default.conf    
├── tools/              
    ├── index.html
    ├── style.css
```

### ADMINER
Adminer is a database management tool via web interface, written in a single PHP file. It’s a light alternative to phpMyAdmin. It allows to:
- View MariaDB tables and data
- Execute SQL queries
- Import/Export databases
- Manage users and permissions
- Modify the table structure

Adminer connects to MariaDB on port **3306** and offers a web interface generally accessible on port **8080***. It supports several types of databases (MySQL, MariaDB, PostgreSQL, SQLite, MongoDB, etc.).

To connect to MariaDB from Adminer:
- **System**: MySQL
- **Server** : `mariadb` (name of the Docker service)
- **User** : the one defined in `.env`
- **Password** : the one defined in `.env`
- **Database** : `wordpress_db`

The service is presented as follows in the repo:
```
requirements/bonus/adminer/
├── Dockerfile          
├── conf/               
    ├── default.conf   
    ├── www.conf   
├── tools/              
    ├── start.sh           
```

### PORTAINER
Portainer is a graphical user interface (GUI) for Docker management. It allows to visually manage all the Docker elements without using the command line:
- View containers (started, stopped)
- See the logs of the containers in real time
- Manage Docker images
- Administer volumes and networks
- Monitor the use of resources (CPU, RAM, network)
- Deploy new containers via graphical interface

Portainer installs itself in a Docker container and connects to the Docker socket (`/var/run/docker.sock`) to control the Docker daemon. It is accessible via a web interface on the port **9443** (HTTPS) or **9000** (HTTP).

It is a very useful tool for:
- Beginners who discover Docker
- Quickly view the state of the infrastructure
- Debugging container issues
- Manage multiple Docker environments from a single interface

The service is presented as follows in the repo:
```
requirements/bonus/portainer/
├── Dockerfile          
```

## How can we start/stop the project ?

To build the dockers, the volumes and run: ``make`>

To stop the docker runnings : ``make down```<

To stop the docker runnings and destroy the volumes: ```make clean``>

To stop and delete all the images and destroy the volumes: ```make fclean`>

These commands use the docker compose commands.

## How can we access to the website and the administration panel ?

(* = https)

[To access WordPress (*443)](https://localhost:443)

[To access Portainer (9001)](http://localhost:9000)

[To access Portainer (*9443)](http://localhost:9443)

[To access site static (8081)](http://localhost:8081)

[To access Adminer (8080)](http://localhost:8080)

## Where can we found all manage credentials ?

We can found every credentials in the hidden files .env. For some safety reason, he isn't in the repo. Here is :
```
DB_USER=logindb
DB_PASSWORD=password1234
DB_ROOT_PASS=passwordroot1234
DB_NAME=wordpress
DOMAIN_NAME=login.42.fr

WP_USER=login1
WP_PASS=password1
WP_MAIL=login@42.com

WP_USER2=login2
WP_PASS2=password2
WP_MAIL2=login2@42.com

REDIS_PASS=redispass1

FTP_USER=ftpuser
FTP_PASSWORD=SecurePassword123!
```

## How can i verify if the services is running correctly ?

There are several ways to ensure that all services in the stack are running correctly.

### 1. Check running containers

First, we can verify that all containers are up and running using Docker Compose:

```bash
docker compose ps

docker logs "docker name"
```
All services should appear with the status Up (or Up (healthy) for MariaDB).
If a container is restarting or exited, it indicates an issue with its configuration or startup script.
Logs help identify configuration errors, missing environment variables, or connection issues between services.

### 2.Verify website accessibility

Using a web browser:

WordPress website (NGINX + PHP-FPM)
The WordPress homepage should load correctly.

WordPress administration panel
https://localhost/wp-admin

Login using the credentials defined in the .env file.

Static website
http://localhost:8081
The static HTML page should be displayed.

If these pages are accessible, it confirms that NGINX, WordPress, and container networking are working properly.

### 3. Verify database connectivity (Adminer)

Connection settings:

System: **MySQL**

Server: **mariadb**

Username: **value of DB_USER**

Password: **value of DB_PASSWORD**

Database: **wordpress**

If Adminer connects successfully and displays database tables, MariaDB is functioning correctly.

5. Verify Redis cache

Redis logs can checked :

```
docker compose logs redis
```
