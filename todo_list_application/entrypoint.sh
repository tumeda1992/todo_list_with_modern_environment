#!/usr/bin/env bash
echo "entrypoint実行"

bundle install
rails s

tail -f "log/development.log"