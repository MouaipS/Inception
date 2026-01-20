FROM debian:bookworm

RUN apt update -y && apt install -y \
    php-fpm \
    # PHP FastCGI Process Manager
    php-mysqli \ 
    # Extension PHP pour MySQL/MariaDB
    wget \
    # Pour télécharger Adminer
    nginx \
    # Serveur web
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /var/www/html && \
wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/htm
# Télécharge Adminer directement depuis GitHub
COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /run/php
# Dossier pour le socket PHP-FPM
COPY tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
EXPOSE 8080
# Port différent pour ne pas conflictuer avec Nginx principal
CMD ["/usr/local/bin/start.sh"]