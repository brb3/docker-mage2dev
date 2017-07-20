FROM smebberson/alpine-consul-base:4.2.0
MAINTAINER Bobby Burden III <bobby@brb3.org>

# Setup nginx
RUN apk add --no-cache nginx \
    && mkdir /www \
    && chown nginx:nginx /www

# Setup mysql
RUN apk add --no-cache mysql mysql-client \
    && mysql_install_db --user=mysql

# Setup php7
RUN apk add --no-cache php7-fpm

# Put files in place
COPY fs /

# Needed for consul management
RUN mkdir /etc/services.d/nginx/supervise/ \
    && mkfifo /etc/services.d/nginx/supervise/control \
    && chown -R root:s6 /etc/services.d/nginx/ \
    && chmod g+w /etc/services.d/nginx/supervise/control

# Expose the ports for nginx
EXPOSE 80 443