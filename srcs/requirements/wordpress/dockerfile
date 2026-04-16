FROM debian:bookworm

RUN apt update && apt upgrade -y
RUN apt-get -y install wget
RUN apt-get install -y php-fpm php-mysql mariadb-client

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /run/php

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/wordpress
ENTRYPOINT ["/usr/local/bin/setup.sh"]
