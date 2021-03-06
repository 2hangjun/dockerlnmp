FROM alpine:3.7

LABEL maintainer="Qing Shan Wu Pian Yun <zjeffort@gmail.com>"

ENV NGINX_VERSION 1.15.0
RUN echo -e "https://mirrors.aliyun.com/alpine/v3.6/main/\nhttps://mirrors.aliyun.com/alpine/v3.6/community/" > /etc/apk/repositories \
	&& CONFIG="\
		--user=nginx \
		--prefix=/usr/local/nginx \
		--sbin-path=/usr/local/nginx/sbin/nginx \
		--conf-path=/usr/local/nginx/conf/nginx.conf \
		--error-log-path=/usr/local/nginx/logs/nginx/error.log \
		--http-log-path=/usr/local/nginx/logs/nginx/access.log \
		--pid-path=/usr/local/nginx/run/nginx/nginx.pid \
		--lock-path=/usr/local/nginx/lock/nginx.lock \
		--with-http_ssl_module \
		--with-http_stub_status_module \
		--with-pcre \
	 	"\
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk update \
	&& apk add --no-cache --virtual .build-deps \
		bash \
		vim \
		gcc \
		libc-dev \
		make \
		pcre-dev \
		linux-headers \
		curl \
		gnupg \
		libxslt-dev \
		gd-dev \
		geoip-dev \
		perl-dev \
		bison \
#		bison-dev \
		zlib-dev \
		libmcrypt-dev \
		php5-mcrypt \
#		mcrypt \
#		mhash-dev \
		openssl-dev \
		libxml2-dev \
#		libcurl-dev \
		bzip2-dev \
		readline-dev \
		libedit-dev \
		sqlite-dev \
		libjpeg-turbo-dev \
#		libjpeg-dev \
		libpng-dev \
		libxpm-dev \
#		libiconv \
		libmcrypt \
		freetype \
		freetype-dev \
		libtool \			
#		libtool-ltdl \
#		libtool-ltdl-dev \
        && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
        && mkdir -p /usr/src \
        && tar -zxC /usr/src -f nginx.tar.gz \
        && rm nginx.tar.gz \
        && cd /usr/src/nginx-$NGINX_VERSION \
        && ./configure $CONFIG \
        && make && make install \
        && rm -rf /usr/src/nginx-$NGINX_VERSION \
        && mkdir -p /usr/local/nginx/logs/nginx \
        && mkdir -p /usr/local/nginx/run/nginx \
        && mkdir -p /usr/local/nginx/lock \
        && mkdir -p /usr/local/nginx/tmp/nginx/client \
        && mkdir -p /usr/local/nginx/tmp/nginx/fcgi \
        && mkdir -p /usr/local/nginx/tmp/nginx/uwsgi \
        && mkdir -p /usr/local/nginx/tmp/nginx/scgi \
        && mkdir -p /usr/local/nginx/conf/vhosts \
        && mkdir -p /var/log/nginx \
        && mkdir -p /data/httpd
                              
COPY nginx/nginx.conf /usr/local/nginx/conf/nginx.conf
COPY nginx/vhosts/default.conf /usr/local/nginx/conf/vhosts/default.conf                     
COPY nginx/pathinfo.conf /usr/local/nginx/conf/pathinfo.conf
COPY nginx/php_fcgi.conf /usr/local/nginx/conf/php_fcgi.conf
COPY nginx/index.html /data/httpd/index.html 

CMD ["/bin/sh"]
