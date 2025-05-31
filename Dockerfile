FROM almalinux:minimal

RUN mkdir /tmp_build

# Rails app lives here
WORKDIR /tmp_build
# Set production environmen

COPY ./composer_install.sh /tmp_build

ENV PHP_VERSION 8.3.9

RUN microdnf -y install tar make gcc  zlib-devel openssl-devel libffi-devel sqlite-devel libxml2-devel
# Install packages needed to build gems
RUN curl -fsSLO --compressed "https://www.php.net/distributions/php-$PHP_VERSION.tar.gz"
RUN tar xzf php-$PHP_VERSION.tar.gz

RUN cd php-$PHP_VERSION && ./configure --prefix=/usr/local/ --enable-sockets --with-openssl && make -j$(getconf _NPROCESSORS_ONLN) && make install
RUN chmod +x ./composer_install.sh && sh ./composer_install.sh && mv composer.phar composer && mv composer /usr/local/bin 
