#!/bin/bash
set -e

sleep 10

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then

    wp core download --allow-root

    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306

    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL

    wp user create --allow-root \
        $USER1_LOGIN $USER1_EMAIL \
        --user_pass=$USER1_PASS \
        --role=author
fi

exec /usr/sbin/php-fpm8.2 -F