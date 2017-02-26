# EmberLoopSql

**NOTE** Currently this is a WiP and running it is a bit sketchy. The READMEs reflect what is intended and not necessarily what is currently implemented.

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

Run `npm install` in the `frontend` and `backend` directories. The simplest way to install and run the project is to run the project root `initialize.sh` script.

## Running the project locally

1. Run the root project `initialize.sh` script
1. `backend` and `frontend` output is redirected to respective `nohup.out` files
1. Ember app is available at [http://localhost:4200](http://localhost:4200)
1. Select Contacts -> All to see data

### Details

Each of datastore, backend, and frontend are separate projects and can be run independently or in concert.

The datastore has bash scripts to simplify initializing, restart, stop, start.

The frontend and backend directories use `npm` to install and start the project.


## TODO

* Create dockerfiles for each of datastore, backend, frontend
* Create docker-compose.yml to link each of above containers
