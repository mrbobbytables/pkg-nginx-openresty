# pkg-ngx-openresty

A simple container that builds and packages an nginx-openresty installer. Should mimic the ubuntu package nginx-full (pretty much meant for pam support).

### Usage

`docker run -it -v $(pwd):/target pkg-ngx-openresty`

it will drop the deb in whatever is mounted to `/target` in the container.
