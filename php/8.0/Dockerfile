FROM php:8.0.1-fpm-alpine

WORKDIR /var/www/html/

# Essentials
RUN apk update
RUN apk add --no-cache \
    zip \
    unzip \
    curl \
    sqlite \
    supervisor \
    tzdata \
    libzip-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql

# Configure timezone
RUN cp /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
RUN echo "Europe/Lisbon" >  /etc/timezone

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY docker/supervisord.ini /etc/supervisor.d/supervisord.ini


# Configure php.ini
COPY docker/php.ini /etc/php8/cli/conf.d/custom.ini


# Configure php-fpm
RUN mkdir -p /run/php/
RUN touch /run/php/php8.0-fpm.pid
RUN touch /run/php/php8.0-fpm.sock

COPY docker/php-fpm.conf /etc/php8/php-fpm.conf

# Build process
# COPY . .
# RUN composer install --no-dev

# Container execution
EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
