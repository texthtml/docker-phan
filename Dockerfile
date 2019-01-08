FROM php:7.3-alpine

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS git binutils && \
    git clone https://github.com/nikic/php-ast.git /tmp/php-ast && \
    docker-php-ext-install pcntl && \
    cd /tmp/php-ast && phpize && ./configure && make install && \
    echo extension=ast.so > /usr/local/etc/php/conf.d/ast.ini && \
    strip -s $(php-config --extension-dir)/ast.so && \
    strip -s $(php-config --extension-dir)/pcntl.so && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
    composer create-project --no-dev --prefer-dist etsy/phan /opt/phan dev-master && \
    rm -r /tmp/php-ast /usr/local/bin/composer && \
    apk del .phpize-deps

ENV PATH $PATH:/opt/phan/

CMD ["phan"]
