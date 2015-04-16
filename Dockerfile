FROM ubuntu:14.04


#openresty version
ENV OR_VER=1.7.10.1

RUN apt-get -y update    \
 && apt-get -y install   \
    git                  \
    build-essential      \
    libgd2-xpm-dev       \
    libgeoip-dev         \
    libncurses5-dev      \
    libpam0g-dev         \
    libpcre3-dev         \
    libreadline-dev      \
    libssl-dev           \
    libxslt1-dev         \
    make                 \
    nginx-full           \
    ruby                 \
    ruby-dev             \
    unzip                \
    wget                 \
    zip                  \
 && gem install fpm
 
COPY ./build.sh ./build.sh

RUN chmod +x ./build.sh            \
 && mkdir -p /target               \
 && mkdir -p /build/modules        \
 && mkdir -p /build/package        \
 && mkdir -p /build/ngx_openresty  \
 && wget -P /tmp http://openresty.org/download/ngx_openresty-${OR_VER}.tar.gz                     \
 && tar -xvzf /tmp/ngx_openresty-${OR_VER}.tar.gz -C /build/ngx_openresty --strip-components=1    \
 && cd /build/modules    \
 && git clone https://github.com/stogh/ngx_http_auth_pam_module.git                    \
 && git clone https://github.com/arut/nginx-dav-ext-module.git                         \
 && git clone https://github.com/gnosek/nginx-upstream-fair.git                        \
 && git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git

CMD ["./build.sh"]
