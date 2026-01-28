#!/bin/sh
# Check if the SQL template file exists
if [ -f /docker-entrypoint-initdb.d/init.sql.template ]; then
    # Replace environment variables in the template and output a real SQL file
    envsubst < /docker-entrypoint-initdb.d/init.sql.template \
            > /docker-entrypoint-initdb.d/init.sql
    # Remove the template file after generating the real SQL file
    rm /docker-entrypoint-initdb.d/init.sql.template
fi

# Check if MariaDB has not been initialized yet (no mysql system database)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    # Initialize the MariaDB data directory with system tables
    
    # Start MariaDB temporarily in the background, without networking
    mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    
    for i in {30..0}; do
        # Loop up to 30 seconds to wait for MariaDB to start
        if mysqladmin ping --silent 2>/dev/null; then
            break
        fi
        # If MariaDB responds to ping, break the loop
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "ERROR: Cannot start MariaDB."
        exit 1
    fi
    # If MariaDB never responded, print an error and exit
    
    if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
        mysql < /docker-entrypoint-initdb.d/init.sql
    fi
    # Execute the initialization SQL script if it exists
    
    if ! mysqladmin shutdown; then
        kill "$pid"
    fi
    # Shutdown MariaDB gracefully, or force kill if shutdown fails
    wait "$pid"
    # Wait for the MariaDB background process to exit completely
fi

exec "$@"