FROM php:5.6-apache

COPY . /var/www/
COPY get-composer.sh /build/get-composer.sh

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \
    export BUILD_DEPS="git zip unzip"; \
    export APP_DEPS=""; \

    set -e -u -x; \

    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ${APP_DEPS} ${BUILD_DEPS}; \

    /build/get-composer.sh; \

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
