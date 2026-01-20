FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

RUN mkdir -p /var/lib/redis && \
    chown -R redis:redis /var/lib/redis && \
    chmod 755 /var/lib/redis

EXPOSE 6379

USER redis

CMD ["redis-server", "/etc/redis/redis.conf"]
