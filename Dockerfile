ARG USER=redis
FROM liammartens/alpine:3.11
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# @env default redis port
ENV REDIS_PORT=6379

# @user Use root user for install
USER root

# @run Install redis
RUN apk add --update redis

# @run Create redis directories
RUN mkdir -p /etc/redis /var/run/redis /var/lib/redis

# @copy Copy default config file
COPY conf/ /etc/redis/

# @run Chown redis directories
RUN chown -R ${USER}:${USER} /etc/redis /var/run/redis /var/lib/redis

# @copy Copy additional run files
COPY .docker ${DOCKER_DIR}

# @run Make the file(s) executable
RUN chmod -R +x ${DOCKER_DIR}

# @user Switch back to non-root user
USER ${USER}

# @healthcheck Simple ping pong healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=2 CMD [[ $(redis-cli -h 127.0.0.1 -p "${REDIS_PORT}" ping) == 'PONG' ]] || exit 1

# @cmd Set command to start redis server
CMD [ "-c", "redis-server /etc/redis/redis.conf --loglevel verbose" ]