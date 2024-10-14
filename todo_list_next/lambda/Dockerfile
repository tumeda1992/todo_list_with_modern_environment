# Nextアプリのルートディレクトリで実行
# docker build -t todo_app_front_lambda:latest -f lambda/Dockerfile .
# docker buildx -t todo_app_front_lambda:latest build -f lambda/Dockerfile .
FROM public.ecr.aws/lambda/nodejs:20

WORKDIR /var/task

COPY package*.json ./
RUN npm install --production

COPY . .
COPY lambda/handler.js ./handler.js

RUN npm run build

CMD ["handler.handler"]
