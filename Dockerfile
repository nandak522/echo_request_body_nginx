FROM nginx:alpine AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
# ENV NGINX_VERSION 1.15.0

# Our NCHAN version
ENV ECHO_REQUEST_VERSION 0.62

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/openresty/echo-nginx-module/archive/v${ECHO_REQUEST_VERSION}.tar.gz" -O echo-nginx-module.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
	tar -zxC /usr/local -f nginx.tar.gz && \
  tar -xzvf "echo-nginx-module.tar.gz" && \
  ECHOREQUESTDIR="/echo-nginx-module-${ECHO_REQUEST_VERSION}" && \
  cd /usr/local/nginx-${NGINX_VERSION} && \
  ./configure --with-compat ${CONFARGS} --add-dynamic-module=${ECHOREQUESTDIR} && \
  make -j2 && make install && rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
