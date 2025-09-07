# Dockerfile
FROM php:7.4-apache

# install mysqli & pdo_mysql
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip \
  && docker-php-ext-install mysqli pdo pdo_mysql \
  && a2enmod rewrite

# copy project into Apache docroot
COPY ./transport/ /var/www/html/

# fix permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
