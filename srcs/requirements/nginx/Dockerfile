FROM debian:bookworm 

#install nginx and create self-signed ssl certificate
RUN apt update -y && apt install nginx -y
RUN mkdir -p /etc/nginx/ssl
RUN apt install openssl -y 
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Angouleme/O=42/OU=42/CN=DOMAIN_NAME/UID=adrouin"

RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/conf.d
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]