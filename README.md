# Phabricator 
**Phabricator** is a collection of web applications which help software companies build better software.

Phabricator includes applications for:
  - reviewing and auditing source code;
  - hosting and browsing repositories;
  - tracking bugs;
  - managing projects;
  - conversing with team members;
  - assembling a party to venture forth;
  - writing stuff down and reading it later;
  - hiding stuff from coworkers; and
  - also some other things.

## Installation
The following command will pull the latest phabricator build.
```sh
$ docker pull princeamd/phabricator:latest
```

## Create Container
The following command creates a container with phabricator and connect it to a MySQL container named 'thomas-mariadb'.
Do not forget to set MYSQL_PASS.
```sh
$ docker run --name thomas-phab -p 127.0.0.1:8084:80 -e MYSQL_USER=root -e MYSQL_PASS='' -e MYSQL_HOST=thomas-mariadb -l thomas-mariadb:database -d princeamd/phabricator:latest
```
License
----
MIT
