# webBudget docker

Here you will find the files to build you own image of webBudget and run it inside a docker environment.

## Complex way: build from scratch

As you noticed, there's two folders here, one to build an image for the backend and another for the frontend, both have
the required files for each application inside its folder.

Build process will download from github the latest version of the application and build it using the tools from each
environment, for backend using gradle and for frontend using yarn. After building, it will create the runner image, the 
one that you actually run with only the required ecosystem to serve the services. For frontend, we use Nginx and for 
backend, OpenJDK.

### Building backend

To build the backend side, inside the respective folder, run:

`docker build --no-cache --progress=plain -t webbudget/backend .`

Backend offers some variables to be set before running it:

- **MAX_MEM_ALLOC** maximum memory used by the Xmx parameter in the JVM config, default `256m`
- **INITIAL_MEM_ALLOC** initial memory used by the Xms parameter in the JVM config, default `128m`
- **DB_HOST** hostname to connect to the database, default `localhost`
- **DB_PORT** port used to connect in the database, default `5432`
- **DB_NAME** database to be used by the application, default `webbudget`
- **DB_USER** username to connect to the database, default `sa_webbudget`
- **DB_PASSWORD** password to connect to the database, default `sa_webbudget`

To run the image you can do it using:

`docker run --rm --name wb-backend -e DB_HOST=172.17.0.1 -e DB_PORT=5434 -it -p 8085:8085 webbudget/backend`

In the example, I will run the image using a Postgres instance already deployed to my docker environment, that's why I'm
setting the `DB_HOST` and `DB_PORT`, the other vars are not set because my configuration used by postgres are compatible
with the default ones.

> **Note:**\
> If you want to use a postgres container with docker, you can do it with this command: 
> `docker run --name wb-postgres -e POSTGRES_USER=sa_webbudget -e POSTGRES_PASSWORD=sa_webbudget -e POSTGRES_DB=webbudget -p 5432:5432 postgres`

### Building frontend

To build the frontend side, inside the respective folder, run:

`docker build --no-cache --progress=plain -t webbudget/frontend .`

Frontend also offer some variables to be set:

- **LOG_REQUESTS** if set to `true`, it will log URL and request params to browser console, default `false` 
- **WEB_PORT** port to be used by the web application, default `8080`
- **API_PROTOCOL** protocol to be used to connect to the backend, default `http`
- **API_URL** the URL to connect to the backend, default `localhost:8085`

To run, type: 

`docker run --rm --name wb-frontend -e API_URL=172.17.0.4:8085 -it -p 8080:80 webbudget/frontend`

In this case I'm setting the `API_URL` to the IP of the backend docker container (can use `docker inspect` to find it), 
also, don't forget to put the port with the URL otherwise the reverse proxy from Nginx might not work.

## Easy way: use docker compose

There's always an easy way! Using docker compose you can avoid doing those steps above and go straight to the point 
where you can run the application with a pré configured environment.

To do it, inside the root folder of this project, run:

`docker compose -p webbudget up`

It will download a pré-built image from a public repository called dockerhub, this image will come with a previous 
released version of the application, it means using the docker compose environment will deliver to you a more stable
version of the software.
