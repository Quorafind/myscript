#!/usr/bin/env bash
########### 脚本信息 ###########
# Author：Bon
# Email：bon@utai.io
# GitHub：Quorafind@github.com
# Date：2018-7-23
# What：Centos下编译安装 jdk, tomcat, nginx
###############################

# 检测是否是 root 用户
if [ "$(whoami)" != 'root' ]; then
    echo "install need root user"
    exit
fi
 
echo "========================preparing install packages======================"
file1=./jdk-8u144-linux-x64.tar.gz
if [ ! -f "$file1" ]; then
    echo "need jdk-8u144-linux-x64.tar.gz，try to downloading."
    curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
fi
 
file2=./apache-tomcat-8.0.45.tar.gz
if [ ! -f "$file2" ]; then
    echo "need apache-tomcat-8.0.45.tar.gz, try to downloading."
    curl -O http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.0.45/bin/apache-tomcat-8.0.45.tar.gz
fi
 
file3=./nginx-1.13.4.tar.gz
if [ ! -f "$file3" ]; then
    echo "need nginx-1.13.4.tar.gz, try to downloading."
    curl -O  http://nginx.org/download/nginx-1.13.4.tar.gz
fi
 
#)install JDK
echo "========================jdk is installing======================"
tar zxvf jdk-8u144-linux-x64.tar.gz
mv jdk1.8.0_144 /usr/local/jdk1.8.0_144
echo "jdk1.8.0_144 is rename to /usr/local/jdk1.8.0_144"
ln -s /usr/local/jdk1.8.0_144 /usr/local/jdk
echo "jdk1.8.0_144 is link to /usr/local/jdk"

 
#)Add the environment variable to /etc/profile
echo "export JAVA_HOME=/usr/local/jdk" >> /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> /etc/profile
source /etc/profile
 
#)Install tomcat
echo "====================apache-tomcat is installing==================="
tar zxvf apache-tomcat-8.0.45.tar.gz
mv apache-tomcat-8.0.45 /usr/local/tomcat1
cp -p /usr/local/tomcat1/bin/catalina.sh /etc/init.d/tomcat1
#)Configure tomcat
sed -i '1a\. /etc/init.d/functions' /etc/init.d/tomcat1
sed -i '2a\:' /etc/init.d/tomcat1
sed -i '3a\JAVA_HOME=/usr/local/jdk' /etc/init.d/tomcat1
sed -i '4a\CATALINA_BASE=/usr/local/tomcat1' /etc/init.d/tomcat1
sed -i '5a\CATALINA_HOME=/usr/local/tomcat1' /etc/init.d/tomcat1

#/etc/init.d/tomcat1 
#chkconfig --add tomcat1
#chkconfig tomcat1 on
 
tar zxvf apache-tomcat-8.0.45.tar.gz
mv apache-tomcat-8.0.45 /usr/local/tomcat2
cp -p /usr/local/tomcat2/bin/catalina.sh /etc/init.d/tomcat2
#)Configure tomcat
sed -i '1a\. /etc/init.d/functions' /etc/init.d/tomcat2
sed -i '2a\:' /etc/init.d/tomcat2
sed -i '3a\JAVA_HOME=/usr/local/jdk/' /etc/init.d/tomcat2
sed -i '4a\CATALINA_BASE=/usr/local/tomcat2' /etc/init.d/tomcat2
sed -i '5a\CATALINA_HOME=/usr/local/tomcat2' /etc/init.d/tomcat2

/etc/init.d/tomcat2
#chkconfig --add tomcat2
#chkconfig tomcat2 on
 
#/usr/local/tomcat1/bin/startup.sh
#/usr/local/tomcat1/bin/startup.sh
 
#install nginx
echo "====================nginx is installing==================="
yum install -y make gcc
yum install -y pcre*
yum install -y openssl*
yum install -y zlib zlib-devel
 
tar zxvf nginx-1.13.4.tar.gz
 
cd nginx-1.13.4 || exit
./configure --prefix=/usr/local/nginx-1.13.4 \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-pcre
make install
 
#make symbol links
ln -s /usr/local/nginx-1.13.4 /usr/local/nginx
 
echo "====================install subversion==================="
#install subversion
yum install -y subversion
 
echo "====================startup application==================="
#tomcat1
/etc/init.d/tomcat1 stop
/etc/init.d/tomcat1 start
#tomcat2
/etc/init.d/tomcat1 stop
/etc/init.d/tomcat2 start
#nginx
/usr/local/nginx/sbin/nginx -s stop
/usr/local/nginx/sbin/nginx