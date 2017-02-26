# Contacts DB as a docker container

This directory contains scripts and mounted volumes that make it easy to create a percona docker container holding the contacts seed data.

The scripts are written for Docker for Mac (v1.12.0-rc4) which eliminates the need for docker-machine management and greatly simplifies using docker on a mac - works much more like a linux environment.

## OS

This initial version was developed on a mac for a mac. Docker for Windows concepts should be identical, but the scripts may have to change (if you are not using WSSL bash). 

## pre-req

- [Docker for Mac](https://docs.docker.com/engine/installation/) installed
- mysqldump command line client installed - if you want to import your own data

## Directory organization

Expected directory structure (required by scripts)

```
datastore/
    conf.d/
    dumps/
    config.sh
    initialize.sh
    ...
```

## Script organization

These scripts became much simpler with the Docker for Mac beta. The initialize script does all the work. the start, stop, and restart scripts are provided for those not so familiar with Docker.

### `initialize.sh`

Use for a fresh git clone or anytime you want a clean slate. Creates the percona container, and seeds data.

- `datastore/conf.d` is mounted as a docker volume and is the standard `my.cnf` extension point

### `restart.sh`

After initial setup, you can use this script to restart the container to, say, pickup config changes.

### `start.sh`

After initial setup, use this command to start the datastore container.

### `stop.sh`

After initial setup, use this command to stop the configdb container.



## Use

To initialize this system, or anytime you want a clean slate:

- `initialize.sh`

To modify `my.cnf`:

- Add modifications to `conf.d` directory (including the `.cnf` extension)
- `restart.sh`

Data is installed in schema `application`, table `contacts`.

- user: root
- pass: root

To connect to the database from the command line:

```shell
$ docker exec -it datastore bash
root@3cab83bf0349:/# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.13-6 Percona Server (GPL), Release '6', Revision 'e3d58bb'

Copyright (c) 2009-2016 Percona LLC and/or its affiliates
Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show schemas;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| application        |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> use application
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A


Database changed
mysql> show tables;
+-----------------------+
| Tables_in_application |
+-----------------------+
| contacts              |
+-----------------------+
1 row in set (0.00 sec)

mysql> select * from contacts;
+-----+------------+---------------+--------------------------------+---------------------------------+---------------------+----------------------+-------+-------+--------------+--------------+------------------------------------+--------------------------------------------+---------------------+---------------------+
| id  | firstName  | lastName      | companyName                    | address                         | city                | county               | state | zip   | phone1       | phone2       | email                              | website                                    | created             | modified            |
# ...
```

To see database logs:

```shell
$ docker logs datastore
Initializing database
2016-07-16T08:17:53.018522Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2016-07-16T08:17:53.332736Z 0 [Warning] InnoDB: New log files created, LSN=45790
```
