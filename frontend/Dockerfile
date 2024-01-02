FROM node:lts-alpine AS build-stage

RUN apk update && apk --no-cache add git

RUN git clone https://github.com/web-budget/front-end.git app

WORKDIR /app

RUN set NODE_ENV=production
RUN npm run docker-build

FROM nginx:stable-alpine AS production-stage

RUN apk update && apk --no-cache add bash

RUN mkdir /app

COPY --from=build-stage /app/dist /app
COPY default.conf.template /etc/nginx/templates/default.conf.template