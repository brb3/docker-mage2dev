mage2dev
===

This docker image is intended for use with Magento 2 extension development.
Do NOT use this for production Magento 2 stores.

PHP-FPM and the Magento CLI should be ran with the `nginx` user/group.
The Magento admin is at `/admin`. Username is `admin` and password is `password1`.

Here's an example `Dockerfile` for an extension using this image:
```
FROM bobbyburden/mage2dev:2.1.7
ARG siteurl=http://localhost.dev:8000/

# Must set the magento_repo_auth to your `composer/auth.json` if you want sample data installed
ARG magento_repo_auth="{}"
ENV SITEURL=$siteurl
ENV COMPOSER_AUTH=$magento_repo_auth

ADD . /www/app/code/My/Extension
RUN mysqld_safe & sleep 5 \
 && cd /www \
 && sudo -Eu nginx bin/magento sampledata:deploy \
 && sudo -u nginx php bin/magento setup:upgrade \
 && chown -R nginx:nginx /www/ \
 && sudo -u nginx bin/magento setup:store-config:set --base-url="$SITEURL" \
 && sudo -u nginx bin/magento setup:di:compile \
 && sudo -u nginx bin/magento setup:static-content:deploy en_US \
 && killall mysqld_safe
 ```