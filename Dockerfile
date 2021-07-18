FROM ubuntu:18.04

MAINTAINER Arief JR <arief666@hotmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y php5.6 php5.6-gd php5.6-mysql php5.6-xmlrpc php5.6-fpm php5.6-dom php5.6-xmlwriter php5.6-xml php5.6-zip php5.6-bz2 php5.6-common curl wget openssh-client php5.6-dev php5.6-cli php5.6-mcrypt php5.6-curl net-tools telnet

# tweak php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/5.6/fpm/php.ini && \
    sed -i -e "s,listen = /run/php/php5.6-fpm.sock,listen = 0.0.0.0:9000,g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/5.6/cli/php.ini && \
    sed -i -e "s/;always_populate_raw_post_data\s*=\s*-1/always_populate_raw_post_data = -1/g" /etc/php/5.6/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/5.6/cli/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/5.6/fpm/php.ini && \
    sed -i -e "s/;always_populate_raw_post_data\s*=\s*-1/always_populate_raw_post_data = -1/g" /etc/php/5.6/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/5.6/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/5.6/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 86/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 24/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 12/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 43/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/memory_limit = 128M/memory_limit = 4096M/g" /etc/php/5.6/fpm/pool.d/www.conf

# ADD IONCUBE

RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension = /usr/lib/php/20131226/ioncube_loader_lin_5.6.so" >> /etc/php/5.6/fpm/php.ini \
    && echo "zend_extension = /usr/lib/php/20131226/ioncube_loader_lin_5.6.so" >> /etc/php/5.6/cli/php.ini

# WORKDIR
WORKDIR /var/www/html

EXPOSE 9000
RUN mkdir /run/php
CMD ["/bin/sh", "-l", "-c", "php-fpm5.6"]
