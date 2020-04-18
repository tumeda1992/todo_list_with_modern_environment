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
ARG apppath="/root/$appname"

# https://qiita.com/enta0701/items/b872eef6d910908c0e6c#7-%E4%B8%8D%E8%A6%81%E3%81%AA%E5%91%BD%E4%BB%A4%E3%81%AF%E6%B8%9B%E3%82%89%E3%81%99
#RUN cd /root \
#  && mkdir $appname \
#  && cd $apppath
WORKDIR $apppath

# docker-composeでコンテナ作成時のマウント設定をすることで以下コードを代替
# COPY ./ .

ADD Gemfile $apppath/Gemfile
RUN bundle install

# EXPOSEコマンドはこのポートを開けるという宣言で何かするというわけではないので不要
# ARG port="3001"
# EXPOSE $port

CMD [ "./entrypoint.sh" ]