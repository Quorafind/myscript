#!/usr/bin/env bash
########### 脚本信息 ###########
# 用户：Bon
# 邮箱：bon@utai.io
# GitHub：Quorafind@github.com
###############################

echo "Please input the version number you need: "
read v_number
echo
if  [ ! -n "$v_number" ] ;then
    echo "You didn't input the version number, please input again or exit" 
    read v_number
else
    echo "the version number you choose is node-v${v_number}"
fi
wait
apt-get update -y
wait
apt-get install python gcc make g++
wait
wget https://nodejs.org/dist/v"${v_number}"/node-v"${v_number}".tar.gz
wait
tar -zxvf node-v"${v_number}".tar.gz
cd node-v"${v_number}" || exit
./configure
wait
make
wait
sudo make install