#!/usr/bin/env bash

bundle install

pidfile="tmp/pids/server.pid"
touch $pidfile
rm $pidfile

port=30418 # 2020/04/18に作ったため
rails s -p $port -b "0.0.0.0" &

tail -f "log/development.log"