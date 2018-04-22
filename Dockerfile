# Creating a WordPress container with XDebug installed
# Removes wp-cli support from Johnrom's docker-wordpress-wp-cli-xdebug
# Docker Hub: https://hub.docker.com/r/threenine/dockpressdebug/
# Github Repo: https://github.com/threenine/dockpressdebug

 # Always use the latest version og WordPress
FROM wordpress:latest
LABEL "uk.co.threenine"="three nine  consulting"
LABEL version="1.0"
LABEL description="Wordpress development environment with xdebug"

ENV XDEBUG_PORT 9000

 #Add sudo in order to run wp-cli as the www-data user
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y sudo less subversion && apt-get -q -y install mysql-server

# Add WP-CLI
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#COPY wp-su.sh /bin/wp
#RUN chmod +x /bin/wp-cli.phar /bin/wp

# Use phpUNit for unit test 
RUN curl -Lo /tmp/phpunit.phar https://phar.phpunit.de/phpunit-5.7.phar \
    && chmod +x /tmp/phpunit.phar \
    && sudo mv /tmp/phpunit.phar /bin/phpunit

# Install sendmail
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x /usr/local/bin/mhsendmail

RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.dev"' > /usr/local/etc/php/conf.d/mailhog.ini

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir=/tmp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "max_input_vars=2000" >> /usr/local/etc/php/conf.d/custom.ini \
    && rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini

EXPOSE 9000
