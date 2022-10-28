FROM node:lts-alpine3.16 as build-stage

# add git binaries to be used later
RUN apk update
RUN apk add git

# download from git and build project
RUN git clone https://github.com/web-budget/front-end.git app

# set our workdir
WORKDIR /app

# yarn install deps and build
RUN yarn docker-build

FROM nginx:stable-alpine as production-stage

# create a folde to put our files
RUN mkdir /app

# copy artifacts from build stage
COPY --from=build-stage /app/dist /app

# copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# run nginx with our app inside
CMD ["nginx", "-g", "daemon off;"]