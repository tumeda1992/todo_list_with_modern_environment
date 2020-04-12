# イメージ作成 `docker build -t todo_app .`
# コンテナ起動 `docker run -it todo_app`
# (引数面倒くさいからdocker composeにする)

# イメージ作成の初期設定
FROM ruby:2.5.3
# ruby:2.5.3のデフォルトCMDのirbを上書き
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

# NOTE ただ動かすことを目的にこのバージョンを固定で入れているが、再考必要
RUN gem install bundler -v 2.1.2

# 暫定 Gemfile.lockがv2以上のbundlerを必要としているがrubyのコンテナは1.17.1なので、Gemfile.lockを削除してお茶を濁す
# https://qiita.com/avicii2314/items/769aacd3b5b949dcbcb8
RUN rm ./Gemfile.lock
RUN bundle install

CMD [ "./entrypoint.sh" ]