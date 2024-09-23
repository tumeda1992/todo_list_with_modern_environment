FROM node:22.9.0

ARG appname=todo_list_next
ARG apppath="/root/$appname"

WORKDIR $apppath

COPY ./ .

COPY package.json ./
COPY yarn.lock ./
RUN yarn install

ENV PORT=30504
EXPOSE $PORT

CMD [ "./entrypoint.sh" ]