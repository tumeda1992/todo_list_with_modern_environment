#!/usr/bin/env bash

yarn install
yarn build
yarn start

tail -f package.json