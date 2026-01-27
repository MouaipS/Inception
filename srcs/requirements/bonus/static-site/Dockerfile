FROM debian:bookworm

RUN apt update -y && apt install -y nginx \
    && rm -rf /var/lib/apt/lists/*

# Copier ton bloc server seulement
COPY conf/default.conf /etc/nginx/sites-available/default

COPY tools/index.html /var/www/html/
COPY tools/style.css /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
