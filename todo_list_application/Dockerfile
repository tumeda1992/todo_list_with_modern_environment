# イメージ作成 `docker build -t todo_app .`
# コンテナ起動 `docker run -it todo_app`
# (引数面倒くさいからdocker composeにする)

# イメージ作成の初期設定
FROM ruby:2.7.1
# rubyのデフォルトCMDのirbを上書き
CMD [ "/bin/bash" ]

ENV LANG C.UTF-8


# アプリケーション用のインフラ設定
ARG appname=todo_list_application

# TODO docker-composeでコンテナ作成時のマウント設定をすることで以下コードを代替
RUN cd /root \
  && mkdir $appname \
  && cd $appname
WORKDIR /root/$appname
COPY ./ .

CMD [ "./entrypoint.sh" ]