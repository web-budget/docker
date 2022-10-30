#!/usr/bin/env bash

JS_FOLDER="/app/js/*.js"

EXISTING_VARS=$(printenv | awk -F= '{print $1}' | sed 's/^/\$/g' | paste -sd,)
export EXISTING_VARS;

for file in $JS_FOLDER;
do
  sed -i 's/API_PROTOCOL/'${API_PROTOCOL}'/g' $file
  sed -i 's/API_HOST/'${API_HOST}'/g' $file
  sed -i 's/"LOG_REQUESTS"/'${LOG_REQUESTS}'/g' $file
done

nginx -g 'daemon off;'