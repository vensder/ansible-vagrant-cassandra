#!/usr/bin/env bash

# docker run --name some-zabbix-web-nginx-mysql \
# 	-e DB_SERVER_HOST="some-mysql-server" \
# 	-e MYSQL_USER="some-user" \
# 	-e MYSQL_PASSWORD="some-password" \
# 	-e ZBX_SERVER_HOST="some-zabbix-server" \
# 	-e PHP_TZ="some-timezone" \
# 	-d zabbix/zabbix-web-nginx-mysql:alpine-3.2

# Linking the container to Zabbix server
# docker run --name some-zabbix-web-nginx-mysql \
# 	--link some-zabbix-server:zabbix-server \
# 	-e DB_SERVER_HOST="some-mysql-server" \
# 	-e MYSQL_USER="some-user" \
# 	-e MYSQL_PASSWORD="some-password" \
# 	-e ZBX_SERVER_HOST="some-zabbix-server" \
# 	-e PHP_TZ="some-timezone" \
# 	-d zabbix/zabbix-web-nginx-mysql:tag

docker run --name some-zabbix-server-mysql \
	-e DB_SERVER_HOST="some-mysql-server" \
	-e MYSQL_USER="some-user" \
	-e MYSQL_PASSWORD="some-password" \
	-d zabbix/zabbix-server-mysql:alpine-3.2.5

# Linking the container to MySQL database
docker run --name zabbix-web \
	--link mysql:mysql \
 	--link zabbix-server:zabbix-server \
	-e DB_SERVER_HOST="mysql" \
	-e MYSQL_USER="some-user" \
	-e MYSQL_PASSWORD="some-password" \
	-e ZBX_SERVER_HOST="zabbix-server" \
	-e PHP_TZ="UTC" \
	-d zabbix/zabbix-web-nginx-mysql:alpine-3.2.5




