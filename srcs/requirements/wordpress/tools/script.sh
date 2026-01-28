#!/bin/sh
# Check if WordPress is NOT already configured
if [ ! -f /var/www/html/wp-config.php ]; then
  # Download the WP-CLI Phar executable from the official repository
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  # Make the WP-CLI file executable
  chmod +x wp-cli.phar
  
  # Download the WordPress core files (allow execution as root)
  ./wp-cli.phar core download --allow-root
  # Generate wp-config.php using environment variables
  # and set the database host to the MariaDB container
  ./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb --allow-root
  # Install WordPress with site URL, title, and admin credentials
  ./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_MAIL --allow-root
  # Create a second WordPress user with the "author" role
  ./wp-cli.phar user create $WP_USER2 $WP_MAIL2 --role=author --user_pass=$WP_PASS2 --allow-root
  # Change the role of the user with ID 2 to "editor"
  ./wp-cli.phar user set-role 2 editor --allow-root
  ./wp-cli.phar theme install astra --activate --allow-root
  
  # Set correct ownership for WordPress files (required by Nginx/PHP)
  chown -R www-data:www-data /var/www/html

  # Set the Redis host in wp-config.php
  ./wp-cli.phar config set WP_REDIS_HOST redis --allow-root
  # Set the Redis port 
  ./wp-cli.phar config set WP_REDIS_PORT 6379 --raw --allow-root
  ./wp-cli.phar config set WP_REDIS_DATABASE 0 --raw --allow-root 
  until nc -z redis 6379; do sleep 1; done
  
    # Install and activate the Redis Object Cache plugin
  ./wp-cli.phar plugin install redis-cache --activate --allow-root
    # Enable Redis caching in WordPress
  ./wp-cli.phar redis enable --allow-root
  ./wp-cli.phar config set WP_CACHE true --raw --allow-root
fi
exec "$@"