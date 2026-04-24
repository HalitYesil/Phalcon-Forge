FROM php:8.3-fpm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libpcre3-dev \
        gcc \
        make \
        autoconf \
        pkg-config \
    && pecl channel-update pecl.php.net \
    && yes '' | pecl install psr \
    && yes '' | pecl install phalcon \
    && docker-php-ext-enable psr phalcon \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
