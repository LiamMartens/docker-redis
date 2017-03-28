#!/bin/bash
chown -R redis:redis /etc/redis /var/log/redis /var/lib/redis
exec "$@"