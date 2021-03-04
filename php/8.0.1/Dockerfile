FROM php:8.0.1-fpm-alpine

WORKDIR /var/www/html/

# Essentials
RUN apk update \
    && apk add --no-cache \
    zip \
    unzip \
    sqlite \
    supervisor \
    tzdata \
    libzip-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql

# Redis
RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    g++ \
    make \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Configure timezone
RUN cp /usr/share/zoneinfo/Europe/Lisbon /etc/localtime \
    && echo "Europe/Lisbon" >  /etc/timezone

# Installing bash
RUN apk add bash \
    && sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing composer
RUN apk add --no-cache curl \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -rf composer-setup.php \
    && apk del curl

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY docker/supervisord.ini /etc/supervisor.d/supervisord.ini


# Configure php.ini
COPY docker/php.ini /etc/php8/cli/conf.d/custom.ini


# Configure php-fpm
RUN mkdir -p /run/php/ \
    && touch /run/php/php8.0-fpm.pid \
    && touch /run/php/php8.0-fpm.sock

COPY docker/php-fpm.conf /etc/php8/php-fpm.conf

# Container execution
EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
