# Redis
This image is built on Alpine 3.10

## Build arguments
* `USER`: The non-root user to be used in the container
* Any build arguments from the `Alpine` base image [liammartens/alpine](https://hub.docker.com/r/liammartens/alpine/)

## Directories
* `/etc/redis`: For Redis configuration (default files are copied in if volume is not used)
* `/var/log/redis`: For Redis log file(s)
* `/var/lib/redis`: For persistent Redis database

## Environment
You can control the Redis configuration using environment variables. Aside from that the `redis` bind IP is automatically set to the container IP.
If you want to override certain Redis configuration variables you can pass them in the following environment variable format `REDIS_PROTECTED_MODE` which will change the `protected_mode` setting in the `redis.conf` file. You can also override the listening port using the `REDIS_PORT` environment variable (defaults to 6379).