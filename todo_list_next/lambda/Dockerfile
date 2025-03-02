FROM public.ecr.aws/lambda/nodejs:20
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /var/task

COPY . .
RUN corepack enable yarn
RUN yarn install
RUN yarn build

CMD ["lambda/lambdaNextJsHandler.handle"]
