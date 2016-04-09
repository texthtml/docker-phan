FROM php:7.0-alpine

RUN apk --update add zlib-dev git && \
    docker-php-ext-install zip mbstring && \
    git clone https://github.com/nikic/php-ast.git /tmp/php-ast && \
    cd /tmp/php-ast && phpize && ./configure && make install && \
    echo extension=ast.so > /usr/local/etc/php/conf.d/ast.ini && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
    composer create-project --no-dev --prefer-dist etsy/phan /opt/phan 0.4 && \
    curl -fSL "https://github.com/krallin/tini/releases/download/v0.9.0/tini-static" -o /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    apk del zlib-dev git && \
	rm -rf /var/cache/apk/* /tmp/php-ast /usr/local/bin/composer

ENTRYPOINT ["tini", "/opt/phan/phan", "--"]
