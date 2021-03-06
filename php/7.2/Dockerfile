FROM php:7.2-fpm-stretch

ENV PROJECT_PATH=.

RUN  dpkg --configure -a

RUN apt-get update -y && apt-get install -y \
        $PHPIZE_DEPS \
        curl \
        libcurl3-dev \
        libtool \
        libxml2 \
        libpng-dev \
        libpq-dev \
        locales \
        tzdata \
        git \
        autoconf \
        g++ \
        libtool \
        make \
        gcc \
        libc-dev \
        pkg-config \
        libmagickwand-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        mysql-client \
        supervisor \
        sysvinit-utils \
        cron

RUN apt-get autoremove

RUN pecl install imagick 

RUN pecl install mcrypt-1.0.2

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN docker-php-ext-enable imagick \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install \
        -j${NPROC} gd \
        curl \
        iconv \
        mbstring \
        pdo \
        pdo_mysql \
        pcntl \
        tokenizer \
        xml \
        zip \
        soap \
        intl \
        bcmath \
    && docker-php-ext-enable \
        mcrypt

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_HOME=/root/.composer
RUN composer global require laravel/installer
ENV PATH /root/.composer/vendor/laravel/installer/bin:/usr/sbin:$PATH


RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN apt-get autoremove


RUN echo "tzdata tzdata/Areas select Europe" > timezone.txt
RUN echo "tzdata tzdata/Zones/Europe select Lisbon" >> timezone.txt
RUN debconf-set-selections timezone.txt
RUN rm /etc/timezone
RUN rm /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /var/www/artisan schedule:run >> /var/log/cron.log 2>&1") | crontab

RUN groupadd supervisor
RUN usermod -a -G supervisor root

COPY queues/*.conf /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisor

WORKDIR /var/www/


ENTRYPOINT ["./entrypoint.sh"]