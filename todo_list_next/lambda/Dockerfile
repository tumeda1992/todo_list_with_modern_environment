# Nextアプリのルートディレクトリで実行
# docker build -t todo_app_front_lambda:latest -f lambda/Dockerfile .
# docker buildx -t todo_app_front_lambda:latest build -f lambda/Dockerfile .

#FROM public.ecr.aws/lambda/nodejs:20
#
#WORKDIR /var/task
#
#COPY package*.json ./
#RUN npm install --production
#
#COPY . .
#COPY lambda/handler.js ./handler.js
#
#RUN npm run build
#
#CMD ["handler.handler"]

# https://aws.amazon.com/jp/blogs/news/implementing-ssr-streaming-on-nextjs-with-aws-lambda-response-streaming/
FROM public.ecr.aws/docker/library/node:20-slim
#FROM public.ecr.aws/lambda/nodejs:18 AS base

# https://github.com/awslabs/aws-lambda-web-adapter
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

ENV PORT=8080
WORKDIR /var/task

# Next.jsアプリケーションを構築
COPY . .
COPY lambda/server.js ./server.js
RUN npm install && npm run build

CMD ["yarn", "start:standalone"]


#CMD ["node", "server.js"]
#CMD ["server.handler"]

# terraform化するときに必要なこと備忘録（terraform後に消していい）
# - 関数URL
#   - CORS設定をしないと生成されたホストからの通信を許可されない
#   - 許可メソッドを*で指定
# - タイムアウト30秒しておく（ssr用）

# 20241011 関数URLでエラーは起きないけど、空の画面表示でパス通りのものを表示できているかも不明。
# あてもないので一旦諦める。解決したら引き続き手動疎通確認を続け、成功したらterraformで自動化