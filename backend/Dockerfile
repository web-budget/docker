FROM gradle:7-alpine as build-stage

# add git binaries to be used later
RUN apk update
RUN apk add git

# set our workdir for the root
WORKDIR /

# download from git and build project
RUN git clone https://github.com/web-budget/back-end.git app

# set our workdir to the new folder with files
WORKDIR /app

RUN gradle --no-daemon -x test clean bootjar

FROM openjdk:17-slim as production-stage

# create a folder to put our files
RUN mkdir /app

# copy jar from build stage
COPY --from=build-stage /app/build/libs/back-end.jar /app

# add entrypoint to the image
ADD entrypoint.sh /app

# change our workdir to the app folder
WORKDIR /app

# expose service port
EXPOSE 8085

# set env vars
ENV MAX_MEM_ALLOC 256m
ENV INITIAL_MEM_ALLOC 128m

ENV DB_HOST localhost
ENV DB_PORT 5432
ENV DB_NAME webbudget
ENV DB_USER sa_webbudget
ENV DB_PASSWORD sa_webbudget

ENTRYPOINT ["/bin/bash", "-c", "/app/entrypoint.sh"]