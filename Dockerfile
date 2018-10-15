FROM alpine:3.8

RUN set -ex; \
        \
        apk update; \
        apk upgrade; \
        apk add --no-cache \
                lighttpd php5-common php5-iconv php5-json php5-gd php5-curl \
                php5-xml php5-pgsql php5-mysql php5-imap php5-cgi fcgi php5-pdo \
                php5-pdo_pgsql php5-pdo_mysql php5-soap php5-xmlrpc php5-posix \
                php5-mcrypt php5-gettext php5-ldap php5-ctype php5-dom \
                php5-mysql mysql-client php5-zlib bash \
        ; \
        wget https://wordpress.org/wordpress-4.9.8.tar.gz && \
        tar -xf wordpress-4.9.8.tar.gz -C /usr/share/ && \
        rm wordpress-4.9.8.tar.gz && \
        chown -R lighttpd /usr/share/wordpress/ && \
        rm -rf /var/www/localhost/htdocs && \
        ln -s /usr/share/wordpress/ /var/www/localhost/htdocs && \
        mkdir -p /run/lighttpd/ && \
        touch /run/lighttpd/lighttpd-fastcgi-php-7.socket && \
        chown -R lighttpd: /run/lighttpd && \
        ln -s /dev/stdout /var/log/lighttpd/error.log && \
        ln -s /dev/stdout /var/log/lighttpd/access.log 

COPY ./lighttpd.conf /etc/lighttpd/lighttpd.conf

COPY ./mod_fastcgi.conf /etc/lighttpd/mod_fastcgi.conf

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
