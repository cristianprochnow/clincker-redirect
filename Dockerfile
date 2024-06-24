FROM debian:12-slim

RUN apt -y update
RUN apt -y upgrade
RUN apt -y install lsb-release
RUN apt -y install ca-certificates
RUN apt -y install apt-transport-https
RUN apt -y install wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt -y update
RUN apt -y install php8.2
RUN apt -y install php8.2-bcmath
RUN apt -y install php8.2-bz2
RUN apt -y install php8.2-intl
RUN apt -y install php8.2-gd
RUN apt -y install php8.2-mbstring
RUN apt -y install php8.2-mysql
RUN apt -y install php8.2-zip
RUN apt -y install php8.2-mysqli
RUN apt -y install php8.2-curl
RUN apt -y install php8.2-psr
RUN apt -y install php8.2-redis
RUN apt -y install php8.2-memcached
RUN apt -y install php-xml

RUN apt -y install libapache2-mod-evasive
RUN apt -y install mariadb-client
RUN apt -y install openssl
RUN apt -y install curl

# enable mods
RUN a2enmod ssl
RUN a2enmod rewrite

# php ini
RUN echo '\nmemory_limit = -1\nmax_execution_time = 0\nupload_max_filesize = 32M\npost_max_size = 32M\nopcache.enable = On\nopcache.validate_timestamps = On\nopcache.memory_consumption = 32\n' >> /etc/php/8.2/cli/php.ini
RUN echo '\nmemory_limit = -1\nmax_execution_time = 0\nupload_max_filesize = 32M\npost_max_size = 32M\nopcache.enable = On\nopcache.validate_timestamps = On\nopcache.memory_consumption = 32\n' >> /etc/php/8.2/apache2/php.ini

# apache envvars
RUN echo 'export PORT=${PORT}' >> /etc/apache2/envvars
RUN echo 'export SERVER_NAME=${SERVER_NAME}' >> /etc/apache2/envvars

# apache setup
RUN echo 'ServerName "${SERVER_NAME}"' >> /etc/apache2/apache2.conf
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN printf '<Directory /var/www/>\n\tOptions Indexes FollowSymLinks MultiViews\n\tAllowOverride All\n\tOrder allow,deny\n\tallow from all\n</Directory>' >> /etc/apache2/sites-enabled/000-default.conf

ENV PORT=80
ENV CONFIG_FILE=''
ENV SERVER_NAME='localhost'

# entrypoint setup
RUN sed -i 's/env -i /env -i PORT=${PORT} SERVER_NAME=${SERVER_NAME} CONFIG_FILE=${CONFIG_FILE} /g' /etc/init.d/apache2
RUN printf '#!/bin/bash\nset -e\n\n: "${APACHE_CONFDIR:=/etc/apache2}"\n: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"\nif test -f "$APACHE_ENVVARS"; then\n  . "$APACHE_ENVVARS"\nfi\n\n: "${APACHE_RUN_DIR:=/var/run/apache2}"\n: "${APACHE_PID_FILE:=$APACHE_RUN_DIR/apache2.pid}"\nrm -f "$APACHE_PID_FILE"\n\nfor e in "${!APACHE_@}"; do\n  if [[ "$e" == *_DIR ]] && [[ "${!e}" == /* ]]; then\n    dir="${!e}"\n    while [ "$dir" != "$(dirname "$dir")" ]; do\n      dir="$(dirname "$dir")"\n      if [ -d "$dir" ]; then\n        break\n      fi\n      absDir="$(readlink -f "$dir" 2>/dev/null || :)"\n      if [ -n "$absDir" ]; then\n        mkdir -p "$absDir"\n      fi\n    done\n    mkdir -p "${!e}"\n  fi\ndone\nexec apache2 -DFOREGROUND "$@"' > ./usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT /usr/local/bin/entrypoint.sh && bash

WORKDIR /var/www/html/
EXPOSE 80 443

# BUILD
# docker build --tag higia-mail:latest -f path\to\project\Dockerfile .
