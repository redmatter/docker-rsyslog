#!/bin/sh

EXPECTED_SIGNATURE=$(php -r 'echo file_get_contents("https://composer.github.io/installer.sig");')
php -r "copy('https://getcomposer.org/installer', '/build/composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', '/build/composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]; then
    exec php /build/composer-setup.php --quiet --install-dir=/build --filename=composer;
fi

>&2 echo 'ERROR: Invalid installer signature'
exit 1
