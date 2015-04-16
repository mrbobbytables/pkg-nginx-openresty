#!/bin/bash

cd /build/ngx_openresty
./configure \
    --with-luajit \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
    --sbin-path=/usr/sbin/nginx \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-debug \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module \
    --with-http_spdy_module \
    --with-http_sub_module \
    --with-http_xslt_module \
    --with-mail \
    --with-mail_ssl_module \
    --add-module=/build/modules/nginx-dav-ext-module \
    --add-module=/build/modules/nginx-upstream-fair \
    --add-module=/build/modules/ngx_http_auth_pam_module \
    --add-module=/build/modules/ngx_http_substitutions_filter_module

make
make install DESTDIR="/build/package"

mkdir -p /build/package/var/lib/nginx
mkdir -p /build/package/etc/default
mkdir -p /build/package/etc/nginx/sites-available
mkdir -p /build/package/etc/nginx/sites-enabled
mkdir -p /build/package/etc/ufw/applications.d
install -m 0777 -D /etc/nginx/sites-available/default /build/package/etc/nginx/sites-available/default
install -m 0644 -D /etc/nginx/nginx.conf /build/package/etc/nginx/nginx.conf

install -m 0644 -D /etc/default/nginx /build/package/etc/default/nginx
install -m 0555 -D /etc/init.d/nginx /build/package/etc/init.d/nginx
install -m 0555 -D /etc/logrotate.d/nginx /build/package/etc/logrotate.d/nginx
install -m 0644 -D /etc/ufw/applications.d/nginx /build/package/etc/applications.d/nginx

cd /target

fpm -s dir -t deb -n ngx-openresty -v "$OR_VER" --iteration 1 -C /build/package \
    --description "nginx/openresty $OR_VER" \
    -d libc6 \
    -d libexpat1 \
    -d libgd3 \
    -d libgeoip1 \
    -d libpam0g \
    -d libpcre3 \
    -d libssl1.0.0 \
    -d libxml2 \
    -d libxslt1.1 \
    -d zlib1g \
    --config-files etc/nginx/fastcgi.conf \
    --config-files etc/nginx/fastcgi.conf.default \
    --config-files etc/nginx/fastcgi_params \
    --config-files etc/nginx/fastcgi_params.default \
    --config-files etc/nginx/koi-utf \
    --config-files etc/nginx/koi-win \
    --config-files etc/nginx/mime.types \
    --config-files etc/nginx/mime.types.default \
    --config-files etc/nginx/nginx.conf \
    --config-files etc/nginx/nginx.conf.default \
    --config-files etc/nginx/scgi_params \
    --config-files etc/nginx/scgi_params.default \
    --config-files etc/nginx/uwsgi_params \
    --config-files etc/nginx/uwsgi_params.default \
    --config-files etc/nginx/win-utf \
    --config-files etc/nginx/sites-available/default \
    --before-install /var/lib/dpkg/info/nginx-common.preinst \
    --after-install /var/lib/dpkg/info/nginx-common.postinst \
    --after-remove  /var/lib/dpkg/info/nginx-common.postrm \
    etc usr var
