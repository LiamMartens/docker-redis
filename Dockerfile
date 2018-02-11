ARG USER=redis
FROM liammartens/alpine
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# @user Use root user for install
USER root

# @run Install redis
RUN apk add --update redis

# @run Create redis directories
RUN mkdir -p /etc/redis /var/log/redis /var/run/redis /var/lib/redis

# @copy Copy default config file
COPY conf/ /etc/redis/

# @run Chown redis directories
RUN chown -R ${USER}:${USER} /etc/redis /var/log/redis /var/run/redis /var/lib/redis

# @volume Add volumes
VOLUME /etc/redis /var/log/redis /var/lib/redis

# @copy Copy additional run files
COPY .docker ${DOCKER_DIR}

# @run Make the file(s) executable
RUN chmod -R +x ${DOCKER_DIR}

# @user Switch back to non-root user
USER ${USER}

# @cmd Set command to start redis server
CMD [ "-c", "redis-server /etc/redis/redis.conf --loglevel verbose" ]