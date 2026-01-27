FROM debian:bookworm

RUN apt update -y && apt install -y \
    php-fpm \
    php-mysqli \
    wget \
    nginx \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html /run/php && chown -R www-data:www-data /run/php

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/adminer.php

COPY conf/default.conf /etc/nginx/sites-available/default
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8080

CMD ["/usr/local/bin/start.sh"]
