#!/bin/bash
# Lancer PHP-FPM en foreground
php-fpm8.2 -F &
# Lancer nginx en foreground
nginx -g "daemon off;"
