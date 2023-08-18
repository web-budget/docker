FROM node:lts-alpine3.16 AS build-stage

# add git binaries to be used later
RUN apk update
RUN apk add git

# download from git and build project
RUN git clone https://github.com/web-budget/front-end.git app

# set our workdir
WORKDIR /app

# yarn install deps and build
RUN yarn docker-build

FROM nginx:stable-alpine AS production-stage

# add bash to run our scripts
RUN apk add bash

# create a folder to put our files
RUN mkdir /app

# copy generated html/js from build stage
COPY --from=build-stage /app/dist /app

# copy entrypoint to the image
COPY entrypoint.sh /app/entrypoint.sh

# copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# set env vars
ENV LOG_REQUESTS false
ENV WEB_PORT 8080
ENV API_PROTOCOL http
ENV API_URL localhost:8085

# expose service port
EXPOSE 80

# run our entrypoint
ENTRYPOINT ["/bin/bash", "-c", "/app/entrypoint.sh"]
