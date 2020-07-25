ARG COMPOSER_VERSION=${COMPOSER_VERSION}

FROM composer:${COMPOSER_VERSION}
RUN composer global require hirak/prestissimo

USER root
RUN docker-php-ext-install pdo_mysql

ENTRYPOINT ["composer"]
CMD [""]
