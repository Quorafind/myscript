#!/bin/sh
########### 脚本信息 ###########
# Author：Bon
# Email：bon@utai.io
# GitHub：Quorafind@github.com
# Date：2018-7-24
# What：服务器上一键部署 Git 和钩子
###############################

# 检测是否是 root 用户
if [ "$(whoami)" != 'root' ]; then
    echo "install need root user"
    exit
fi
echo "Please input your pub_key(for example: id_rsa.pub)"
read pub_keys
echo "Please input your website name"
read website_name
echo

#初始化环境并且安装对应的包
sudo apt-get update
sudo apt-get install git-core
wget -c https://raw.githubusercontent.com/Quorafind/myscript/master/shell/single-nginx/nginx_ubuntu.sh && chmod +x nginx_ubuntu.sh && ./nginx_ubuntu.sh
wait
cd /usr/local/nginx/conf || exit
sed "68c server_name ${website_name} ${website_name};" nginx.conf
sed "70c root /var/www/hexo;" nginx.conf
/etc/init.d/nginx stop
/etc/init.d/nginx start

#创建 git 用户
sudo adduser "git"
chmod 740 /etc/sudoers
cd etc || exit
sed -i '/root ALL=(ALL:ALL) ALL/a\git ALL=(ALL:ALL)' sudoers
sudo chmod 440 /etc/sudoers

#实现 ssh 链接
cd /home/git || exit
mkdir .ssh && cd .ssh || exit
touch authorized_keys
echo "$pub_keys" >> authorized_keys
cd /home/git || exit

#创建 git 钩子
mkdir hexo.git && cd "${website_name}".git || exit
git init --bare
cd /var/www || exit
sudo mkdir hexo
cd /home/git/hexo.git/hooks || exit
cat>post-receive<<EOF
#!/bin/bash
GIT_REPO=/home/git/hexo.git
TMP_GIT_CLONE=/tmp/hexo
PUBLIC_WWW=/var/www/hexo
rm -rf ${TMP_GIT_CLONE}
git clone $GIT_REPO $TMP_GIT_CLONE
rm -rf ${PUBLIC_WWW}/*
cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}
EOF
chmod +x post-receive
sudo /etc/init.d/nginx restart
chown -R git:git /home/git
chown -R git:git /tmp/hexo
chown -R git:git /var/www/hexo

