FROM almalinux:minimal

RUN mkdir /tmp_build

# Rails app lives here
WORKDIR /tmp_build
# Set production environmen

ENV PHP_VERSION 8.3.9

RUN microdnf -y install tar make gcc  zlib-devel openssl-devel libffi-devel sqlite-devel libxml2-devel
# Install packages needed to build gems
RUN curl -fsSLO --compressed "https://www.php.net/distributions/php-$PHP_VERSION.tar.gz"
RUN tar xzf php-$PHP_VERSION.tar.gz

RUN cd php-$PHP_VERSION && ./configure --prefix=/usr/local/ --with-openssl && make -j$(getconf _NPROCESSORS_ONLN) && make install

