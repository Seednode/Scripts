#!/usr/bin/env bash
# a script to build nginx against openssl-dev on ubuntu/debian/arch linux/alpine linux
# includes nginx fancyindex, rtmp, and headers-more modules

# you can skip a given dependency check by setting the `skipdeps` environment variable
# i.e. `skipdeps=golang,gnupg ./build-nginx.sh`

# select the nginx version to build
LATESTNGINX="1.17.1"

# choose where to put the build files
BUILDROOT="$HOME/nginx-edge"

# choose what software and version the server will report as
SERVER="GNU Netcat"
VERSION="0.7.1"

# set core count for make
core_count="$(grep -c ^processor /proc/cpuinfo)"

# if the user is skipping dependency checks, warn them
if [ -z "$skipdeps" ]; then 
	true
else
	# prompt for user acknowledgement
	echo -e "\nYou appear to be skipping a dependency check."
	echo "Please be VERY careful, as this may cause the build to fail, or generate corrupt binaries."
	read -p $'If you are sure you still want to run this script, please type ACCEPT and press Enter.\n\n' acknowledgement

	# if the user acknowledges, begin the build
	if [ "$acknowledgement" = "ACCEPT" ]; then
		echo -e ""
	# otherwise, exit with error
	else
		echo -e "\nExiting script...\n"
		exit 1
	fi
fi 

# if pacman is installed, use the arch dependencies
if command -v pacman 2>&1 >/dev/null; then
	# create array of dependencies
	declare -a dependencies=("gcc" "cmake" "git" "gnupg" "go" "pcre" "libcurl-compat" "zlib" "sudo")

	# check if dependencies are installed; if not, list the missing dependencies. if not available for the current os, error out
	for dependency in "${dependencies[@]}"; do
		if [[ $skipdeps =~ .*"$dependency".* ]]; then
			true
		else
			sudo pacman -Qi "$dependency" >/dev/null 2>&1 \
			|| { echo >&2 "$dependency is not installed. Please install it and re-run the script."; exit 1; }
		fi
	done

# if apt is installed, use the debian dependencies
elif command -v apt 2>&1 >/dev/null; then
	# create array of dependencies
	declare -a dependencies=("build-essential" "gcc" "g++" "cmake" "git" "gnupg" "golang" "libpcre3-dev" "curl" "zlib1g-dev" "libcurl4-openssl-dev" "sudo")

	# check if dependencies are installed; if not, list the missing dependencies. if not available for the current os, error out
	for dependency in "${dependencies[@]}"; do
		if [[ $skipdeps =~ .*"$dependency".* ]]; then
			true
		else
			sudo dpkg-query -W "$dependency" >/dev/null 2>&1 \
			|| { echo >&2 "$dependency is not installed. Please install it and re-run the script."; exit 1; }
		fi
	done

# if apk is installed, install the alpine dependencies
elif command -v apk 2>&1 > /dev/null; then
	apk update && apk add gcc g++ cmake git gnupg go pcre-dev curl zlib-dev openssl-dev sudo

# otherwise list the expected packages and ask the user to install them manually
else
	echo -e "\nCompatible package manager not found."
	echo -e "\nThe following packages are typically required: gcc, g++, cmake, git, gnupg, go, pcre, libcurl, zlib. Please install them manually and re-run the script.\n"
	exit 1
fi

# delete any previous build directory
if [ -d "$BUILDROOT" ]; then
	sudo rm -rf "$BUILDROOT"
fi

# create the build directory
mkdir -p "$BUILDROOT"
cd "$BUILDROOT"

# clone the openssl dev branch
git clone https://github.com/openssl/openssl.git
cd openssl

# use default openssl configurations
./config

# build openssl
make -j"$core_count"

# fetch the latest version of nginx
mkdir -p "$BUILDROOT/nginx"
cd "$BUILDROOT"/nginx
curl -L -O "http://nginx.org/download/nginx-$LATESTNGINX.tar.gz"
tar xzf "nginx-$LATESTNGINX.tar.gz"
cd "$BUILDROOT/nginx/nginx-$LATESTNGINX"

# change the nginx server name strings
sed -i "s#ngx_http_server_string\[\].*#ngx_http_server_string\[\] = \"Server: $SERVER\" CRLF;#" $BUILDROOT/nginx/nginx-$LATESTNGINX/src/http/ngx_http_header_filter_module.c
sed -i "s#ngx_http_server_full_string\[\].*#ngx_http_server_full_string\[\] = \"Server: $SERVER $VERSION\" CRLF;#" $BUILDROOT/nginx/nginx-$LATESTNGINX/src/http/ngx_http_header_filter_module.c
sed -i "s#ngx_http_server_build_string\[\].*#ngx_http_server_build_string\[\] = \"Server: $SERVER $VERSION\" CRLF;#" $BUILDROOT/nginx/nginx-$LATESTNGINX/src/http/ngx_http_header_filter_module.c

# fetch the fancy-index module
git clone https://github.com/aperezdc/ngx-fancyindex.git "$BUILDROOT"/ngx-fancyindex

# fetch the nginx-rtmp module
git clone https://github.com/Seednode/nginx-rtmp-module.git "$BUILDROOT"/nginx-rtmp-module

# fetch the headers-more module
git clone https://github.com/openresty/headers-more-nginx-module.git "$BUILDROOT"/nginx-headers-more

# configure the nginx source to use openssl
sudo ./configure --prefix=/usr/share/nginx \
	--add-module="$BUILDROOT"/ngx-fancyindex \
	--add-module="$BUILDROOT"/nginx-rtmp-module \
	--add-module="$BUILDROOT"/nginx-headers-more \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
        --pid-path=/run/nginx.pid \
        --lock-path=/run/lock/subsys/nginx \
        --user=www-data \
        --group=www-data \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --without-select_module \
        --without-poll_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
	--with-openssl="$BUILDROOT/openssl" \
	--with-cc-opt="-g -O3 -march=native -fPIE -fstack-protector-all -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -I $BUILDROOT/openssl" \
	--with-ld-opt="-Wl,-Bsymbolic-functions -Wl,-z,relro -L $BUILDROOT/openssl/"

# build nginx
sudo make -j"$core_count"
sudo make install

# if systemctl is installed (fairly strong indicator systemd is in use), add a service unit file
if command -v systemctl 2>&1 >/dev/null; then
# add systemd service file
cat <<EOL | sudo tee /lib/systemd/system/nginx.service
[Unit]
Description=NGINX with OpenSSL-dev
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/usr/bin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOL

# enable and start nginx
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

# reload nginx config
sudo systemctl restart nginx.service
fi
