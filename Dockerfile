# Creating a WordPress container with XDebug installed
# Removes wp-cli support from Johnrom's docker-wordpress-wp-cli-xdebug
# Docker Hub: https://hub.docker.com/r/threenine/dockpressdebug/
# Github Repo: https://github.com/threenine/dockpressdebug

 # Always use the latest version og WordPress
FROM wordpress:latest
LABEL "uk.co.threenine"="three nine  consulting"
LABEL version="1.0"
LABEL description="Wordpress development environment with xdebug"
# install and configure XDebug

RUN yes | pecl install xdebug \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.profiler_output_dir=/tmp" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini