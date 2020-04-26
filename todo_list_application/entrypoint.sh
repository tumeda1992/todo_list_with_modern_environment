#!/usr/bin/env bash

bundle install

pidfile="tmp/pids/server.pid"
touch $pidfile
rm $pidfile

port=30418 # 2020/04/18に作ったため
pre_process="$(ps -ef |grep ":$port" |grep -v "grep" |awk '{print $2}')"
kill -9 $pre_process
rails s -p $port -b "0.0.0.0" &

tail -f "log/development.log"