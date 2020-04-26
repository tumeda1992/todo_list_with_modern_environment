#!/usr/bin/env bash

yarn install
# yarn build
yarn start

# 不本意だけど、起動後に以下のコードを打っている
# docker-compose run  --service-ports todo_app_view yarn start