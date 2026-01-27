#!/bin/sh

if [ -f /docker-entrypoint-initdb.d/init.sql.template ]; then
  envsubst < /docker-entrypoint-initdb.d/init.sql.template \
           > /docker-entrypoint-initdb.d/init.sql
  rm /docker-entrypoint-initdb.d/init.sql.template
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    
    for i in {30..0}; do
        if mysqladmin ping --silent 2>/dev/null; then
            break
        fi
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "ERREUR: Impossible de se connecter à MariaDB"
        exit 1
    fi
    
    if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
        mysql < /docker-entrypoint-initdb.d/init.sql
    fi
    
    if ! mysqladmin shutdown; then
        kill "$pid"
    fi
    wait "$pid"
fi

exec "$@"