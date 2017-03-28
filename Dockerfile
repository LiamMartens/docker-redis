FROM alpine:edge
MAINTAINER Liam Martens (hi@liammartens.com)

# add redis user
RUN adduser -D redis

# run updates
RUN apk update && apk upgrade

# add packages
RUN apk add --update --no-cache \
    tzdata bash wget curl nano htop perl

# install redis
RUN apk add --update --no-cache redis

# create redis directories
RUN mkdir -p /etc/redis /var/log/redis /var/run/redis /var/lib/redis && \
    chown -R redis:redis /etc/redis /var/log/redis /var/run/redis /var/lib/redis

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown redis:redis /etc/localtime /etc/timezone

# set volume
VOLUME ["/etc/redis", "/var/log/redis", "/var/lib/redis"]

# copy run file
COPY scripts/run.sh /home/redis/run.sh
RUN chmod +x /home/redis/run.sh
COPY scripts/continue.sh /home/redis/continue.sh
RUN chmod +x /home/redis/continue.sh

ENTRYPOINT ["/home/redis/run.sh", "su", "-m", "redis", "-c", "/home/redis/continue.sh /bin/bash"]