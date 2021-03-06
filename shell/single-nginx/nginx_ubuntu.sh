#!/usr/bin/env bash
########### 脚本信息 ###########
# Author：Bon
# Email：bon@utai.io
# GitHub：Quorafind@github.com
# Date：2018-7-24
# What: Ubuntu 下安装 nginx
##############################

# 检测是否是 root 用户
if [ "$(whoami)" != 'root' ]; then
    echo "install need root user"
    exit
fi
sudo apt-get update
wait
sudo apt-get install screen git wget net-tools
wait
screen -S nginx-real
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#安装依赖环境
sudo apt-get install patch openssl make cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs autoconf kernel-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libcap diffutils
#安装PCRE
wget http://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.gz
tar zxf pcre-8.36.tar.gz
cd pcre-8.36/ || exit
./configure && make && make install
cd ../ || exit
#安装NGINX
wget http://nginx.org/download/nginx-1.6.3.tar.gz
tar zxf nginx-1.6.3.tar.gz
cd nginx-1.6.3/ || exit
./configure --user=nobody --group=nobody --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6 --with-http_sub_module --with-http_spdy_module
make && make install
wait
echo
cd ../ || exit

ln -s /usr/local/lib/libpcre.so.1 /lib
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
rm -f /usr/local/nginx/conf/nginx.conf
mkdir -p /home/wwwroot/default
chmod +w /home/wwwroot/default
mkdir -p /home/wwwlogs
chmod 777 /home/wwwlogs
chown -R nobody:nobody /home/wwwroot/default

wget -c http://soft.vpser.net/lnmp/ext/init.d.nginx
cp init.d.nginx /etc/init.d/nginx
chmod +x /etc/init.d/nginx
chkconfig --level 345 nginx on
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables-save
ldconfig
wget -c https://raw.githubusercontent.com/Quorafind/myscript/master/shell/single-nginx/nginx.conf
mv nginx.conf /usr/local/nginx/conf/
/etc/init.d/nginx start