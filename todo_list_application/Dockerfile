# イメージ作成 `docker build -t todo_app .`
# コンテナ起動 `docker run -it todo_app`
# (引数面倒くさいからdocker composeにする)

# アプリケーションのディレクトリを設定
ARG appname=todo_list_application
ARG apppath="/root/$appname"
ARG ruby_version=3.3.5

FROM ruby:${ruby_version} AS bundle-dependency-builder
ARG appname
ARG apppath

ENV LANG=C.UTF-8
WORKDIR $apppath

COPY Gemfile  ./
COPY Gemfile.lock ./
RUN bundle install --path vendor/bundle

FROM ruby:${ruby_version}

ENV LANG=C.UTF-8

ARG appname
ARG apppath

WORKDIR $apppath

COPY --from=bundle-dependency-builder $apppath/vendor/bundle ./vendor/bundle

# docker-composeでコンテナ作成時のマウント設定をすることで代替可能だが、
# fargateのようにイメージ時点でソースコードを含めなければならないケースのため
COPY ./ .

ENV PORT=30418
EXPOSE $PORT
COPY entrypoint.sh ./
CMD [ "./entrypoint.sh" ]
#CMD [ "/bin/bash" ] # rubyのデフォルトCMDのirbを上書き。entrypoint使えないとき一時的に記載
