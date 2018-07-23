#!/bin/sh
########### 脚本信息 ###########
# Author：Bon
# Email：bon@utai.io
# GitHub：Quorafind@github.com
# Date：2018-7-23
# What：快速关闭启动 tomcat
###############################

bin=$(cd "$(dirname "$0")" || exit; pwd)
pid=$(ps aux | grep tomcat | grep -v grep | grep -v restart | grep "${bin}" | awk '{print $2}') 

if [ -n "${pid}" ]; then
    echo "Shutdown..."
    sh "${bin}"/shutdown.sh
    sleep 3

    pid=$(ps aux | grep tomcat | grep -v grep | grep -v restart | grep "${bin}" | awk '{print $2}')
    if [ -n "${pid}" ]; then
        kill -9 "${pid}"
        sleep 1
    fi
fi

echo "Startup..."
sh "${bin}"/startup.sh
if [ "$1" = "-v" ]; then
    tail -f "${bin}"/../logs/catalina.out
fi