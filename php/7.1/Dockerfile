FROM php:7.1-fpm-alpine


RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libmcrypt-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
    && apk add --no-cache \
        curl \
        git \
        imagemagick \
        libmcrypt \
        mysql-client \
        postgresql-libs \
    && apk add --update \
        autoconf \
        g++ \
        libtool \
        make \
        icu-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        mcrypt \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
        soap \
        intl \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && apk del -f .build-deps


WORKDIR /var/www

ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]