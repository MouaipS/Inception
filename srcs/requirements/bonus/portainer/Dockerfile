FROM debian:bookworm

# Installation des dépendances nécessaires
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Création du répertoire de données Portainer
RUN mkdir -p /data

# Téléchargement et extraction de TOUT Portainer (pas juste le binaire)
RUN curl -L https://github.com/portainer/portainer/releases/download/2.33.5/portainer-2.33.5-linux-amd64.tar.gz \
    -o /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /tmp && \
    mv /tmp/portainer /opt/portainer && \
    chmod +x /opt/portainer/portainer && \
    rm -rf /tmp/portainer.tar.gz

# Exposition des ports
EXPOSE 9000 9443 8000

# Volume pour la persistance des données
VOLUME /data

# Démarrage de Portainer avec le bon chemin
CMD ["/opt/portainer/portainer", "--data", "/data"]