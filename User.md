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

Dans la partie mandatory, on a 3 services qui s'aggencent de cette maniere :
```
NGINX (Port 443)
    ↓ FastCGI
PHP-FPM (Port 9000) ← Exécute WordPress
    ↓ MySQL Protocol
MariaDB (Port 3306)
```

### NGINX

The first services is Nginx, a web server with TLS Protocol (TLSv1.2/TLSv1.3). Son role dans Inception est celui d'un revers proxy : il recoit les requetes https des utilisateurs et les transmets au services wordpress. Il retourne ensuite les reponses au client. C'est le seul docker en lien avec le "monde exterieur" via le port **443** (qui correspond au https).

Il gere egalement le chiffrement TLS (Transport Layer Security), un protocol de securite qui permet de crypter les communications entre un client et un serveur. Il possede le certificat SSL qui permet a notre site d'etre en https et non http. 

Il communique avec WordPress via le protocle FastCGI (utile pour les pages dynamiques). Les fichiers dynamiques sont gerer a PHP-FPM(le manager FastCGI) alors que les fichiers des sites statiques sont directements dans le volumes.

Le service se present ainsi dans le repo :
```
requirements/nginx/
├── Dockerfile          # Construction de l'image
├── conf/
│   └── nginx.conf      # Configuration NGINX
└── tools/
    └── setup.sh        # Script de configuration
```

### WORDPRESS

Le second service est Wordpress. C'est une CMS, un Content Management System. Il permet de créer et gérer un site web dynamique. WordPress traite toutes les requêtes dynamiques transmises par NGINX. Il est ecrit en PHP. Il communique uniquement avec Nginx sur le port **9000** et avec Mariadb sur le **3306**.

Il a un volume persistant en ```/var/www/html```. Ce volume a ete mappe dans ```/home/login/data/wordpress```.

Le service se present ainsi dans le repo :
```
requirements/wordpress/
├── Dockerfile          # Construction de l'image
├── conf/
│   └── www.conf        # Configuration wordpress
└── tools/
    └── script.sh       # Script de configuration
```
### MARIADB

MariaDB est le système de gestion de base de données relationnelle de l'infrastructure. Il stocke toutes les données persistantes de WordPress : articles, pages, utilisateurs, commentaires, paramètres, etc. C'est le backend de stockage essentiel pour le bon fonctionnement du site. On utilise Mariadb car c'est un fork open-source de MySQL créé en 2009. Il est compatible avec MySQL (même protocole, même syntaxe SQL)

Le service se present ainsi dans le repo :
```
requirements/mariadb/
├── Dockerfile          # Construction de l'image
├── conf/
│   └── 50-server.conf  # Configuration mariadb
└── tools/
    └── entrypoint.sh   # Script de configuration
    └──init.sql.template
```

### REDIS
Redis est un système de cache en mémoire (in-memory cache) qui améliore les performances de WordPress. Il stocke en RAM les résultats des requêtes MySQL complexes effectuées par WordPress. Lorsqu'un utilisateur demande une page pour la première fois, WordPress interroge MariaDB. Redis met ensuite en cache le résultat de cette requête. Quand un autre utilisateur demande la même page, Redis fournit directement les données depuis la mémoire RAM, sans interroger MariaDB. Cela réduit considérablement le temps de chargement des pages et la charge sur la base de données.

Redis communique avec WordPress sur le port **6379** (port standard Redis). Il nécessite l'installation du plugin "Redis Object Cache" dans WordPress pour fonctionner. La configuration se fait via les constantes `WP_REDIS_HOST` et `WP_REDIS_PORT` dans le fichier `wp-config.php`.

Le service se présente ainsi dans le repo :
```
requirements/bonus/redis/
├── Dockerfile          # Construction de l'image
├── conf/
│   └── redis.conf      # Configuration Redis
└── tools/
    └── script.sh       # Script de configuration (si nécessaire)
```

### FTP SERVER
Le serveur FTP (File Transfer Protocol) permet de transférer des fichiers vers et depuis le site WordPress via un client FTP. Il pointe directement vers le volume WordPress (`/var/www/html`), permettant ainsi de télécharger, uploader ou modifier les fichiers du site (thèmes, plugins, médias) sans passer par l'interface WordPress.

Le serveur utilise **vsftpd** (Very Secure FTP Daemon), un serveur FTP sécurisé pour Linux. Il écoute sur le port **21** (port FTP standard) et utilise également des ports passifs (généralement 21100-21110) pour les transferts de données.

Les utilisateurs FTP doivent être configurés avec des credentials (nom d'utilisateur et mot de passe) stockés dans les variables d'environnement. Le serveur FTP partage le même volume que WordPress pour un accès direct aux fichiers du site.

Le service se présente ainsi dans le repo :
```
requirements/bonus/ftp/
├── Dockerfile          # Construction de l'image
├── conf/
│   └── vsftpd.conf     # Configuration vsftpd
└── tools/
    └── setup.sh       # Script de configuration
```

### STATIC SITE
Le site statique est un site web simple créé dans un langage autre que PHP (HTML/CSS). Il peut servir de vitrine, de portfolio, ou de page de présentation. Contrairement à WordPress qui génère du contenu dynamique, ce site sert des pages statiques pré-générées.

Le site statique possède son propre conteneur avec un serveur web (NGINX) pour servir les fichiers HTML, CSS. Il écoute sur un port différent **8081**.

Ce service démontre la flexibilité de Docker : plusieurs services web peuvent coexister dans la même infrastructure, chacun dans son conteneur isolé.

Le service se présente ainsi dans le repo :
```
requirements/bonus/website/
├── Dockerfile          # Construction de l'image
├── conf/               
    ├── default.conf    # Fichier de configuration
├── tools/              # Code source du site statique
    ├── index.html
    ├── style.css
```

### ADMINER
Adminer est un outil de gestion de base de données via interface web, écrit en un seul fichier PHP. C'est une alternative légère à phpMyAdmin. Il permet de :
- Visualiser les tables et données de MariaDB
- Exécuter des requêtes SQL
- Importer/Exporter des bases de données
- Gérer les utilisateurs et permissions
- Modifier la structure des tables

Adminer se connecte à MariaDB sur le port **3306** et offre une interface web accessible généralement sur le port **8080**. Il supporte plusieurs types de bases de données (MySQL, MariaDB, PostgreSQL, SQLite, MongoDB, etc.).

Pour se connecter à MariaDB depuis Adminer :
- **Système** : MySQL
- **Serveur** : `mariadb` (nom du service Docker)
- **Utilisateur** : celui défini dans `.env`
- **Mot de passe** : celui défini dans `.env`
- **Base de données** : `wordpress_db`

Le service se présente ainsi dans le repo :
```
requirements/bonus/adminer/
├── Dockerfile          # Construction de l'image
└── conf/              # Configuration (optionnelle)
```

### PORTAINER
Portainer est une interface graphique (GUI) de gestion Docker. Il permet de gérer visuellement tous les éléments Docker sans utiliser la ligne de commande :
- Visualiser les conteneurs (démarrés, arrêtés)
- Voir les logs des conteneurs en temps réel
- Gérer les images Docker
- Administrer les volumes et réseaux
- Monitorer l'utilisation des ressources (CPU, RAM, réseau)
- Déployer de nouveaux conteneurs via interface graphique

Portainer s'installe lui-même dans un conteneur Docker et se connecte au socket Docker (`/var/run/docker.sock`) pour contrôler le daemon Docker. Il est accessible via une interface web sur le port **9443** (HTTPS) ou **9000** (HTTP).

C'est un outil très utile pour :
- Les débutants qui découvrent Docker
- Visualiser rapidement l'état de l'infrastructure
- Debugger des problèmes de conteneurs
- Gérer plusieurs environnements Docker depuis une seule interface

Le service se présente ainsi dans le repo :
```
requirements/bonus/portainer/
├── Dockerfile          # Construction de l'image (ou utilisation image officielle)
└── conf/              # Configuration (optionnelle)
```



## How can we start/stop the project ?

Pour build les dockers, les volumes et run : ```make```

Pour stopper les runnings docker : ```make down```

Pour stopper les runnings docker et detruire les volumes : ```make clean```

Pour stopper et supprimer toutes les images et detruire les volumes : ```make fclean```

Ces commandes utilise les commandes du docker compose.

## How can we access to the website and the administration panel ?

(* = https)

[Pour acceder a Wordpress (*443)](https://localhost:443)

[Pour acceder a Portainer (9000)](http://localhost:9000)

[Pour acceder a Portainer (*9443)](http://localhost:9443)

[Pour acceder au site static (8081)](http://localhost:8081)

[Pour acceder a Adminer (8080)](http://localhost:8080)

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