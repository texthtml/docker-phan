FROM php:7

RUN apt-get update
RUN apt-get install -y zlib1g-dev git libzmq3 libzmq3-dev
RUN docker-php-ext-install zip mbstring

RUN git clone https://github.com/nikic/php-ast.git /tmp/php-ast && \
    cd /tmp/php-ast && phpize && ./configure && make install && \
    echo extension=ast.so > /usr/local/etc/php/conf.d/ast.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

RUN set -x \
    && curl -fSL "https://github.com/krallin/tini/releases/download/v0.5.0/tini" -o /usr/local/bin/tini \
    && chmod +x /usr/local/bin/tini

ENV PHAN_VERSION 0.4

RUN git clone https://github.com/etsy/phan /opt/phan && \
    cd /opt/phan && git checkout $PHAN_VERSION && \
    cd /opt/phan && composer install

ENTRYPOINT ["tini", "/opt/phan/phan", "--"]
