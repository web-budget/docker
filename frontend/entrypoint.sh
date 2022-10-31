#!/usr/bin/env bash

NGINX_CONF_FILE="/etc/nginx/nginx.conf"
JS_FOLDER="/app/js/*.js"

# replace placeholders on vue js files
for file in $JS_FOLDER;
do
  sed -i 's/WEB_PORT/'${WEB_PORT}'/g' $file
  sed -i 's/"LOG_REQUESTS"/'${LOG_REQUESTS}'/g' $file
done

# replace placeholders on nginx conf file
sed -i 's/API_PROTOCOL/'${API_PROTOCOL}'/g' $NGINX_CONF_FILE
sed -i 's/API_URL/'${API_URL}'/g' $NGINX_CONF_FILE

# start nginx
nginx -g 'daemon off;'