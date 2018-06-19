FROM arm32v7/php:7.1-apache-jessie

MAINTAINER Benoît Vézina a.k.a. XtremXpert <benoit@xtremxpert.com>

ENV VERSION 2.9.3

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        curl \
        imagemagick \
        libav-tools \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        mediainfo \
        unzip \
        wget

RUN docker-php-ext-install \
        exif \
        gd \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql

RUN curl -L "http://piwigo.org/download/dlcounter.php?code=${VERSION}" -o /piwigo.zip \
    && unzip /piwigo.zip -d /var/www \
    && rm -rf /var/www/html \
    && mv /var/www/piwigo /var/www/html \
    && rm /piwigo.zip \
    && sed -i "s#if (\$result)#if (pwg_db_num_rows(\$result))#" /var/www/html/include/functions_session.inc.php

RUN apt-get autoremove --purge -y unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY assets/database.inc.php /var/www/html/local/config/database.inc.php

VOLUME ["/var/www/html/galleries", "/var/www/html/themes", "/var/www/html/plugins", "/var/www/html/local"]
