FROM php:8.2.2-fpm


RUN apt-get clean all && apt-get update && apt-get install -y --no-install-recommends --allow-downgrades \
        git \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libjpeg \
        libwebp-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install calendar

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer
RUN  chmod a+x /usr/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
COPY ./upload.ini /usr/local/etc/php/conf.d/upload.ini

RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick
