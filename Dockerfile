FROM almalinux:minimal

RUN mkdir /tmp_build

# Rails app lives here
WORKDIR /tmp_build
# Set production environmen

COPY ./composer_install.sh /tmp_build

ENV PHP_VERSION 8.3.9

RUN microdnf -y install tar make gcc g++  zlib-devel openssl-devel libffi-devel sqlite-devel libxml2-devel git
RUN git clone https://github.com/Kitware/CMake.git && cd CMake && ./bootstrap && make -j$(getconf _NPROCESSORS_ONLN) && make install && cd ../ && curl -LO https://libzip.org/download/libzip-1.11.4.tar.gz && tar zxvf libzip-1.11.4.tar.gz && cd libzip-1.11.4 && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/libzip && make && make install 

# Install packages needed to build gems
RUN curl -fsSLO --compressed "https://www.php.net/distributions/php-$PHP_VERSION.tar.gz"
RUN tar xzf php-$PHP_VERSION.tar.gz

RUN export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/libzip/lib64/pkgconfig" && cd php-$PHP_VERSION && ./configure --prefix=/usr/local/ --enable-sockets --with-openssl --with-zip && make -j$(getconf _NPROCESSORS_ONLN) && make install
RUN chmod +x ./composer_install.sh && sh ./composer_install.sh && mv composer.phar composer && mv composer /usr/local/bin 
