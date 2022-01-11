FROM composer:2.2.4 as builder

WORKDIR /app/

COPY composer.* ./

RUN composer install --no-dev --no-interaction --no-progress --optimize-autoloader

FROM php:7.4-apache

RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd && \
    a2enmod headers && \
    a2enmod env && \
    a2enmod rewrite && \
    sed -ri -e 's/^([ \t]*)(<\/VirtualHost>)/\1\tHeader set Access-Control-Allow-Origin "*"\n\1\2/g' /etc/apache2/sites-available/*.conf

WORKDIR /var/www/html/

COPY --from=builder /app/vendor /var/www/html/vendor

RUN echo 'SetEnv ALLOWED_HOST ${ALLOWED_HOST}' > /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv FILE_INPUT_NAME ${FILE_INPUT_NAME}' > /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv FILE_PATH ${FILE_PATH}' > /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv SALT ${SALT}' > /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv SECRET ${SECRET}' > /etc/apache2/conf-enabled/environment.conf

RUN chmod -R 755 /tmp/

RUN chown -R www-data:www-data /tmp/

COPY . /var/www/html/

RUN mkdir /var/www/html/images

RUN chown -R www-data:www-data /var/www/html/

RUN chmod -R 755 /var/www/html/

EXPOSE 80

RUN service apache2 restart