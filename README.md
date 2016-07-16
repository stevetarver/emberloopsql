# EmberLoopSql

Pronounced "ember-loop-cicle"

This project contains a full stack in a single repo:

- Percona server v5.7
- StrongLoop (IBM API Connect) v5.0.2.0
- Ember.js v2.6.3

[Why Percona](https://www.percona.com/software/mysql-database/percona-server)? Percona provides a MySQL drop-in replacement that is faster and provides superior tooling and monitoring. The Percona Live 2016 conference showed how Percona fully embraces Open Source - it's about community, datastores (not just MySQL), and devops.

[Why StrongLoop](https://strongloop.com/)? Although IBM purchased StrongLoop and feature delivery seems a bit slow recently, it provides forward/reverse database engineering, a strong foundation for microservices with all the necessary connectors, middleware concepts, a Swagger explorer, and a json:api connector that plays well with Ember. You can likely get your API started with zero code, just reverse engineered database config files.

[Why Ember](https://ember-cli.com/) I have built one app in Ember and already love it. Apple SproutCore's Tom Dale and RoR, Rust, and TC-39's Yehuda Katz embrace engineering principles and a devotion to developer joy that show in the Ember environment, ecosystem and excellent community. All of the framework design decisions seem natural and solid and with a little understanding of the core principles, the framework feels very comfortable. Boilerplate code simply evaporates and you can solve business problems quickly.

## Installing the project

### Pre-req

With git, docker, node and npm installed, you will need the following globals

Ember

- `npm install -g bower`
- `npm install -g ember-cli`
- `npm install -g phantomjs`

StrongLoop

- `npm install -g apiconnect`

### Install

Run the project's `install.sh` script to install each project's dependencies.

## Running the project locally

Each of datastore, backend, and frontend are separate projects and can be run independently or in concert.

Each directory contains a `start.sh` script that will start the frontend and backend in local, development mode, and the datastore as a docker container. 

You may need to tweek the backend's datasource connection to point to the correct docker machine.

## Building the project

### Building

Each of datastore, backend, and frontend are their own docker containers anticipating future scaling; a POC of sorts.

Run the project's `build.sh` script to build each of the docker containers.

When the docker images are built, run `start-docker.sh` to start and connect each of the containers. Then you can view the app via browser.

### Mac




