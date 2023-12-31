FROM node:lts-alpine3.16 AS build-stage

# add git binaries to be used later
RUN apk update && apk --no-cache add git

# download from git and build project
RUN git clone https://github.com/web-budget/front-end.git app

# set our workdir
WORKDIR /app

# yarn install deps and build
RUN yarn docker-build

FROM nginx:stable-alpine AS production-stage

# add bash to run our scripts
RUN apk update && apk --no-cache add bash

# create a folder to put our files
RUN mkdir /app

# copy generated html/js from build stage
COPY --from=build-stage /app/dist /app

# copy nginx config
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template