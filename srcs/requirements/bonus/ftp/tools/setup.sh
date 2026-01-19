#!/bin/bash

# Créer l'utilisateur FTP s'il n'existe pas
if ! id -u $FTP_USER > /dev/null 2>&1; then
useradd -m -d /var/www/html $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi
# useradd -m : Crée un utilisateur avec son home directory
# -d /var/www/html : Home = dossier WordPress
# chpasswd : Définit le mot de passe
mkdir -p /var/run/vsftpd/empty
# Dossier requis par vsftpd pour le chroot
exec "$@"
# Lance la commande CMD du Dockerfile