#!/usr/bin/env bash

yarn install
# yarn build
port=30504
yarn dev -p ${port}

# 不本意だけど、起動後に以下のコードを打っている
# docker-compose run  --service-ports todo_app_view yarn start