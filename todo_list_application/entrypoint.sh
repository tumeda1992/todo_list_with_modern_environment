#!/usr/bin/env bash

echo "entrypoint実行"

bundle install

pidfile="tmp/pids/server.pid"
touch $pidfile
rm $pidfile

port=3001
rails s -p $port -b "0.0.0.0" &

tail -f "log/development.log"