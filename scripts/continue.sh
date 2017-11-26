#!/bin/bash
export HOME=/home/$(whoami)

if [ -z "$REDIS_PORT" ]; then
	export PHP_PORT=6379
fi

if [ -z "$TIMEZONE" ]; then
	export TIMEZONE='UTC'
fi

# get ip addresses and export them as environment variables
export REDIS_TCP=`awk 'END{print $1}' /etc/hosts`

# function check redis conf empty / bak
checkRedisConf() {
	if [[ `cat /etc/redis/redis.conf` =~ "^\s*$" ]]; then
		mv /etc/redis/redis.conf.bak /etc/redis/redis.conf
	else
		rm /etc/redis/redis.conf.bak
	fi
}

#
# set redis variables
#
# REDIS_PROTECTED_MODE -> protected-mode
#
ENV_VARS=($(env))
for VAR in "${ENV_VARS[@]}"; do
	VAR_NAME=$(echo $VAR | cut -d'=' -f 1)
	VAR_VALUE=$(echo $VAR | cut -d'=' -f 2)
	if [[ "$VAR_NAME" =~ "REDIS_"* ]] && [[ "$VAR_NAME" != "REDIS_PORT" ]]; then
		REDIS_SETTING=$(echo $VAR_NAME | cut -d'_' -f 2-)
		REDIS_SETTING=$(echo $REDIS_SETTING | awk '{print tolower($0)}')
		REDIS_SETTING=$(echo $REDIS_SETTING | perl -pe "s/_/-/")
		perl -p -i.bak -e "s/^$REDIS_SETTING\s+.*/$REDIS_SETTING $VAR_VALUE/gi" /etc/redis/redis.conf
		checkRedisConf
	fi
done

# set timezone
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime
echo $TIMEZONE > /etc/timezone

# set redis listen port
perl -p -i.bak -e "s/bind\s+(.+)/bind $REDIS_TCP/gi" /etc/redis/redis.conf
checkRedisConf

# set redis listen port
perl -p -i.bak -e "s/port\s+(.+)/port $REDIS_PORT/gi" /etc/redis/redis.conf
checkRedisConf

# run user scripts
if [[ -d ${ENV_DIR}/files/.$(whoami) ]]; then
	chmod +x ${ENV_DIR}/files/.$(whoami)/*
	run-parts ${ENV_DIR}/files/.$(whoami)
fi

echo "Starting redis on $REDIS_PORT"
redis-server /etc/redis/redis.conf --loglevel verbose

$SHELL