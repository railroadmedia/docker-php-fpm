FROM php:7.1-fpm

MAINTAINER Caleb Favor <caleb@drumeo.com>

# Software's Installation
RUN apt-get update \
  &&apt-get install -y --no-install-recommends \
        curl \
        libz-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        nano \
  &&rm -rf /var/lib/apt/lists/*

# Enable PHP Extentions
RUN docker-php-ext-install mcrypt \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd


# Add PHP Config
ADD config/laravel.ini /usr/local/etc/php/conf.d
ADD config/laravel.pool.conf /usr/local/etc/php-fpm.d/

# Install Composer
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
