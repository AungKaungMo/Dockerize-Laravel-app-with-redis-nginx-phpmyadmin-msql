FROM php:8.2-fpm-alpine

# To set user and id dynamically when image built
ARG user=developer
ARG uid=1000

#apk update = update alpine package
#apk add = add or install essential package that describe below
#curl = command line tool for data transfer
#libpng-dev = required for handling png image
#libxml2-dev = required for xml handling
#zip & unzip = zipping and unzipping project folder
#shadow = adds user and group management capabilities 
#U can add other necessary packages

RUN apk update && apk add \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    shadow

#install pdo and mysql pdo extensions
#install node.js & npm without keeping a local cache to reduce image size

RUN docker-php-ext-install pdo pdo_mysql \
    && apk --no-cache add nodejs npm

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

#Add a new user with
#1.The group memberships: www-data (common web server group) and root
#2.The user ID provided via the $uid argument
#3.The home directory set to /home/$user 
RUN adduser -G www-data -u $uid -h /home/$user -D $user

#Create .composer dir in user's home dir
#Change ownership of the user's home  

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:www-data /home/$user

WORKDIR /var/www/docker-test

USER $user