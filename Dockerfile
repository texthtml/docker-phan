FROM php:7.0-alpine

RUN apk add --no-cache git && \
    git clone https://github.com/nikic/php-ast.git /tmp/php-ast && \
    apk del git && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS && \
    cd /tmp/php-ast && phpize && ./configure && make install && \
    apk del .phpize-deps && \
    echo extension=ast.so > /usr/local/etc/php/conf.d/ast.ini && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
    composer create-project --no-dev --prefer-dist etsy/phan /opt/phan 0.4 && \
    rm -rf /var/cache/apk/* /tmp/php-ast /usr/local/bin/composer && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ tini
RUN echo $PHPIZE_DEPS
ENTRYPOINT ["/sbin/tini", "--", "/opt/phan/phan"]
