ARG ALPINE_VERSION=3.15
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Oscar Caballero <hola@ehupi.com>"
LABEL Description="Container with Nginx 1.20 & PHP 8.0 Alpine."

WORKDIR /var/www/html

RUN apk add --no-cache \
  curl \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fpm \
  php8-gd \
  php8-intl \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-phar \
  php8-session \
  php8-xml \
  php8-xmlreader \
  php8-zlib \
  php8-fileinfo \
  php8-xmlwriter \
  php8-tokenizer \
  php8-pdo_mysql \
  php8-exif \
  supervisor

RUN ln -s /usr/bin/php8 /usr/bin/php

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx

USER nobody

COPY --chown=nobody src/ /var/www/html/

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
