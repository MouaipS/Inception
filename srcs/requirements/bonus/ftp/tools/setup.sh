#!/bin/bash

set -e
# Exit immediately if any command fails (error handling)
if ! id -u $FTP_USER > /dev/null 2>&1; then
# Check if the user defined by $FTP_USER does not exist
useradd -m -d /var/www/html $FTP_USER
# Create the user with a home directory at /var/www/html
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
# Set the password for the user to the value of $FTP_PASSWORD
fi
chown -R "$FTP_USER":"$FTP_USER" /var/www/html
chmod -R 755 /var/www/html
mkdir -p /var/run/vsftpd/empty
# Create the empty directory required by vsftpd for runtime files
exec "$@"
