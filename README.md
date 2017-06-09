docker-phabricator
==================

A docker composition for Phabricator :
    docker build -t phabricator:latest https://github.com/deonthomasgy/docker-phabricator.git
You will need to link with a db
    docker run --name thomas-phab -e MYSQL_USER=root -e MYSQL_PASS='' -e MYSQL_HOST=localhost -d -d phabricator:latest
