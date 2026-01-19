FROM debian:bookworm

#update apt before installing nginx 
RUN apt update -y && apt install nginx -y
#open a new folder to save the certif and the key
RUN mkdir -p /etc/nginx/ssl
#install openssl to handle certif ssl
RUN apt install openssl -y
#make a CSR
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Angouleme/O=42/OU=42/CN=DOMAIN_NAME/UID=adrouin"
#a folder to safe NGINX config file
RUN mkdir -p /var/run/nginx
#to copy nginx.conf 
COPY ./conf/nginx.conf /etc/nginx/conf.d
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]