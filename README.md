# webBudget docker

Here you will find the files to build your own image of webBudget and run it inside a docker environment.

## Complex way: build from scratch

As you noticed, there's two folders here, one to build the backend and another for the frontend image, both have
the required files for each application inside its folder.

Build process will download from github the latest version of the application (from main branch) and build it. 

After building, it will create the image, the one that you actually run with only the required ecosystem to serve the 
applications.

### Building backend

Inside the backend folder from this project, runs:

`docker build --build-arg JAVA_VERSION=17 -t arthurgregorio/webbudget-backend:latest .`

Before running the docker image you should get the information to pass as environment variables:

- **DATABASE_URL** database connection URL, default _localhost:5433_
- **DATABASE_NAME** database name, default _webbudget_ 
- **DATABASE_USER** database user, default _sa_webbudget_
- **DATABASE_PASSWORD** database user password, default _sa_webbudget_

> If you don't have a local instance of Postgres running, you can do it using docker:
> `docker run --name wb-database -e POSTGRES_USER=sa_webbudget -e POSTGRES_PASSWORD=sa_webbudget -e POSTGRES_DB=webbudget -p 5432:5432 postgres`
 
- **MAIL_HOST** the host for the e-mail service, **required**, no defaults
- **MAIL_USER** the user for the e-mail service, **required**, no defaults
- **MAIL_PASSWORD** the password for the e-mail service, **required**, no defaults
- **MAIL_PORT** e-mail service port for connection, default _587_
- **MAIL_DEFAULT_FROM_ADDRESS** default from e-mail address, default _noreply@webbudget.com.br_
- **MAIL_REPLY_TO_ADDRESS** reply e-mail address, default _noreply@webbudget.com.br_

> For a mocked e-mail service I would recommend the use of [MailTrap](https://mailtrap.io/)

- **APPLICATION_JWT_TIMEOUT** timeout, in seconds, for authentication JWT token expiration, default _2400_
- **APPLICATION_PORT** used to specify the port that the application should listen to incoming connections, default _8085_

Run the application using the command bellow, remember to put the required environment variables for your setup:

```shell
docker run --rm --name wb-backend -it \ 
    -e MAIL_HOST=my.email.host.com \ 
    -e MAIL_USER=the-user \ 
    -e MAIL_PASSWORD=the-password \
    -p 8085:8085 arthurgregorio/webbudget-backend:latest 
```

### Building frontend

Inside the frontend folder of this project, runs:

`docker build -t arthurgregorio/webbudget-frontend:latest .`

Available environment variables:

- **API_URL** set the backend API to connect, this should point the the backend service, is required and defaults to _localhost:8085_ 

And to run: 

```shell
docker run --name wb-frontend -it \
    -e API_URL=http://127.0.0.1:8085 \
    -p 8080:80 arthurgregorio/webbudget-frontend:latest
```

Usually if you are running both projects, point the API_URL to the docker gateway should be enough.

## Using docker compose

There's always an easy way! Using docker compose you can avoid doing those steps above and go straight to the point 
where you can run the application with a pra configured environment. To do it, in the root folder of the project, runs:

> First, before running the command bellow, configure inside the file the environment variables for the e-mail service

`docker compose -p webbudget up`

It will download the images from docker hub and you just need to change inside the file the environment vars you want to
set.

## Accessing the application

After deploying the docker image using any of the approaches above you will be able to open your browser and type 
`http://localhost:8080/` (if you choose 8080 for the frontend, if not, change the port here) to access the application. 

Default username is `admin@webbudget.com.br` with password `admin`. Enjoy!

Found any bug or has suggestions? Feel free to add a ticket to any of the repositories for the project.