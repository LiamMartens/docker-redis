ARG USER='redis'
FROM liammartens/alpine
LABEL maintainer="hi@liammartens.com"

ENV OWN_BY="${USER}:${USER}"
ENV OWN_DIRS="${OWN_DIRS} /etc/redis /var/log/redis /var/lib/redis"

# install redis
RUN apk add --update --no-cache redis

# create redis directories
RUN mkdir -p /etc/redis /var/log/redis /var/run/redis /var/lib/redis && \
    chown -R ${USER}:${USER} /etc/redis /var/log/redis /var/run/redis /var/lib/redis

# set volume
VOLUME /etc/redis /var/log/redis /var/lib/redis

# copy run file
COPY scripts/continue.sh ${ENV_DIR}/scripts/continue.sh
RUN chmod +x ${ENV_DIR}/scripts/continue.sh