FROM smebberson/alpine-consul-base:4.2.0
MAINTAINER Bobby Burden III <bobby@brb3.org>
ARG magento_repo_auth
ARG magento_url

# Setup nginx
RUN apk add --no-cache nginx \
    && mkdir /www \
    && chown nginx:nginx /www

# Setup mysql
RUN apk add --no-cache mysql mysql-client \
    && mysql_install_db --user=mysql

# Setup php7
RUN apk add --no-cache php7 php7-fpm php7-phar php7-iconv php7-mbstring \
    php7-curl php7-gd php7-intl php7-mcrypt php7-openssl php7-pdo_mysql \
    php7-xml php7-soap php7-xsl php7-zip php7-json php7-ctype php7-session \
    && wget -O /usr/bin/composer http://getcomposer.org/download/1.4.2/composer.phar \
    && chmod +x /usr/bin/composer \
    && ln -s /usr/bin/php7 /usr/bin/php

# Put files in place
COPY fs /

# Needed for consul management of nginx
RUN mkdir /etc/services.d/nginx/supervise/ \
    && mkfifo /etc/services.d/nginx/supervise/control \
    && chown -R root:s6 /etc/services.d/nginx/ \
    && chmod g+w /etc/services.d/nginx/supervise/control

# Install Magento2
ENV COMPOSER_AUTH=$magento_repo_auth
ENV MAGEDIR=/www
ENV MAGEURL=$magento_url
RUN apk add --no-cache sudo && install-magento

# Expose the ports for nginx
EXPOSE 80 443