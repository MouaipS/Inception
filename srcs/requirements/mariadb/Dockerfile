FROM debian:bookworm

RUN apt update -y && apt install -y \
    mariadb-server \
    mariadb-client \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

RUN mkdir -p /etc/mysql/mariadb.conf.d
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /docker-entrypoint-initdb.d
COPY tools/init.sql.template /docker-entrypoint-initdb.d/

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

RUN rm -rf /var/lib/mysql/*

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mariadbd"]