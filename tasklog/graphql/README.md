# TODO
- 『初めてのGraphQL』を読む。
  - Express + MongoDBでのApollo実装は一旦飛ばす
  - 全部読んだあとにネットでGraphQLRubyのドキュメントを見て、いち早く実装できるようにする
  - その後興味あればExpressとMongoDBを学ぶ
- ↑の写経
- サンプルアプリを作る
- 本リポジトリの開発環境に活かす


# 『初めてのGraphQL』を読んで
- ApolloClient
  - 最悪curlで事足りる
  - 強力なツールを使いたい場合に使う
  - ApolloServer, ApolloClientともに思想を知りたいな→Apolloで有名なのはClientっぽい。Server側もあるかもだけど。
  
# サンプルで組んでみて
- GraphQLRuby、GraphQLRailsを入れてみる
  - ドキュメント
    - [github](https://github.com/rmosolgo/graphql-ruby)
    - [Qiita](https://qiita.com/dkawabata/items/4fd965ee6d7295386a8b)
  - 雑記
    - `rails generate graphql:install`で起動。以下のファイルができる
      - `app/graphql/~`
      - `app/controllers/graphql_controller.rb`
    - サンプルであるクエリ例が`testField`とキャメル
      - APIのURLならスネークにしたいけど、jsのコードの中に書くコードだからキャメルでいっか。無理にデフォルトを変えないで。
    - `app/graphql/types/query_type.rb`
      - ここで型とデータ返却処理を記述
      - 型はファイル分かれているけど、処理もここに書かなきゃいけないから、でっかいアプリケーションコントローラーみたいになりそう。
      - すぐにファイル分けんと気持ち悪い。処理は別ファイルにしてroutes.rbみたいな集約を行う分け方になりそう。やり方は諸説あるけど
        - `def user(id:) UserResolver.user end`みたいな移譲
        - `UserResolver`とか別ファイルにフィールド定義も書いて~~includeする~~[それ用の記法を使う](https://qiita.com/kshibata101/items/4fa24fea575c5e5e0ce1)
      - [ここ](https://blog.spacemarket.com/code/graphql-ruby-concerns/)でもタイプすらも分けるのやっててすぐやりそう。input型とかでディレクトリをわけるかビジネス的な塊で分けるかは別として。