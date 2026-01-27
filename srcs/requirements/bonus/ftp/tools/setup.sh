#!/bin/bash

set -e
if ! id -u $FTP_USER > /dev/null 2>&1; then
useradd -m -d /var/www/html $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi
chown -R "$FTP_USER":"$FTP_USER" /var/www/html
chmod -R 755 /var/www/html
mkdir -p /var/run/vsftpd/empty
exec "$@"
