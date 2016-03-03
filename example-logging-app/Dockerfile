FROM php:5.6-apache

COPY . /var/www/

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \
    export BUILD_DEPS="git zip unzip"; \
    export APP_DEPS=""; \

    set -e -u -x; \

    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ${APP_DEPS} ${BUILD_DEPS}; \

    mkdir /build && cd /build; \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php; \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === 'fd26ce67e3b237fffd5e5544b45b0d92c41a4afe3e3f778e942e43ce6be197b9cdc7c251dcde6e2a52297ea269370680') { exit(0); } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); }"; \
    php composer-setup.php --install-dir=/build --filename=composer; \
    php -r "unlink('composer-setup.php');"; \

    cd /var/www/; \
    /build/composer install --no-dev --no-progress --optimize-autoloader --no-interaction; \
    rm composer.json composer.lock; \
    rm -rf /build; \

    apt-get remove -y $BUILD_DEPS; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/{apt,dpkg,cache,log}/; \

    echo "date.timezone = UTC" > /usr/local/etc/php/php.ini; \
)
