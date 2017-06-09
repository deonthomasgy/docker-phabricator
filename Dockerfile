#
# Docker image for running https://github.com/phacility/phabricator
#

FROM    debian:jessie
MAINTAINER  Deon Thomas <deon.thomas.gy@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

# TODO: review this dependency list
RUN     apt-get clean && apt-get update && apt-get install -y \
	        git \
            apache2 \
            curl \
            libapache2-mod-php5 \
            libmysqlclient18 \
            mercurial \
            mysql-client \
            php-apc \
            php5 \
            php5-apcu \
            php5-cli \
            php5-curl \
            php5-gd \
            php5-json \
            php5-ldap \
            php5-mysql \
            python-pygments \
            sendmail \
            subversion \
            tar \
            sudo \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# For some reason phabricator doesn't have tagged releases. To support
# repeatable builds use the latest SHA
ADD     download.sh /opt/download.sh

ARG PHABRICATOR_COMMIT=74d86f09023
ARG ARCANIST_COMMIT=3c4735795a
ARG LIBPHUTIL_COMMIT=a900d7b63e

WORKDIR /opt
RUN     bash download.sh phabricator $PHABRICATOR_COMMIT
RUN     bash download.sh arcanist    $ARCANIST_COMMIT
RUN     bash download.sh libphutil   $LIBPHUTIL_COMMIT

# Setup apache
RUN     a2enmod rewrite
ADD     phabricator.conf /etc/apache2/sites-available/phabricator.conf
RUN     ln -s /etc/apache2/sites-available/phabricator.conf \
            /etc/apache2/sites-enabled/phabricator.conf && \
        rm -f /etc/apache2/sites-enabled/000-default.conf

# Setup phabricator
RUN     mkdir -p /opt/phabricator/conf/local /var/repo
ADD     local.json /opt/phabricator/conf/local/local.json
RUN     sed -e 's/post_max_size =.*/post_max_size = 32M/' \
          -e 's/upload_max_filesize =.*/upload_max_filesize = 32M/' \
          -e 's/;opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' \
          -e 's/;always_populate_raw_post_data/always_populate_raw_post_data/' \
          -i /etc/php5/apache2/php.ini
RUN     ln -s /usr/lib/git-core/git-http-backend /opt/phabricator/support/bin
RUN     /opt/phabricator/bin/config set phd.user "root"
RUN     echo "www-data ALL=(ALL) SETENV: NOPASSWD: /opt/phabricator/support/bin/git-http-backend" >> /etc/sudoers

EXPOSE  80
ADD     entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD     ["start-server"]
