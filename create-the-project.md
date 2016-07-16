# How this project was made

## Basic directory strucure and framework init

A little goofiness here, working around each framework expecting to be in it's own directory named after the project...

With all dependencies installed:

```shell
$ mkdir emberloopsql && cd emberloopsql
$ git init
$ ember init
$ mkdir frontend
$ cp * frontend/
$ mkdir datastore
$ mkdir backend && cd backend
$ apic loopback
? What's the name of your application? emberloopsql
? Enter name of the directory to contain the project: backend
? What kind of application do you have in mind? empty-server (An empty LoopBack API, without any configured models or datasources)
    Created package.json
    Created serverod)
    Created server/boot
    Created server/boot/root.js
    Created server/config.json
    Created server/datasources.json
    Created server/middleware.json
    Created server/middleware.production.json
    Created server/model-config.json
    Created server/server.js
$ mv backend/* .
$ rm -rf backend
```

Create a backend `.gitignore` to exclude `node_modules/`.

Now wade through all the files and create your first git commit.

## Datastore

First develop the scripts to stand up our datastore and seed data. Then we can develop the api and frontend.

No magic here, just using bash to pull the docker image, build a container, and install the seed data.

## Backend

With the database running, we can reverse engineer an API.

## Frontend

Now that we have an API to build on, we can start fleshing out the presentation.
