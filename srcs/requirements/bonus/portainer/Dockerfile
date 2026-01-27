FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data

RUN curl -L https://github.com/portainer/portainer/releases/download/2.33.5/portainer-2.33.5-linux-amd64.tar.gz \
    -o /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /tmp && \
    mv /tmp/portainer /opt/portainer && \
    chmod +x /opt/portainer/portainer && \
    rm -rf /tmp/portainer.tar.gz

EXPOSE 9000 9443 8000

VOLUME /data

CMD ["/opt/portainer/portainer", "--data", "/data"]