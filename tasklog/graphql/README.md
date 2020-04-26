# TODO
- 『初めてのGraphQL』を読む。
  - Express + MongoDBでのApollo実装は一旦飛ばす
  - 全部読んだあとにネットでGraphQLRubyのドキュメントを見て、いち早く実装できるようにする
  - その後興味あればExpressとMongoDBを学ぶ
- ↑の写経
- サンプルアプリを作る
- 本リポジトリの開発環境に活かす

# 結論始める時どんな手順を踏むか
- server側
  - [この記事](https://qiita.com/dkawabata/items/)のようにやって`rails generate graphql:install`とか打つ
  - [CORS](https://qiita.com/sugo/items/9c5f9cc5d88e6d7efa2d#rack-cors%E3%81%AE%E5%88%A9%E7%94%A8)の設定
- client側
  - 

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
- jsにapolloを入れて
  - 本の通りやって通信失敗。なぜかOPTIONSメソッドが使われていた
    - [公式ドキュメント](https://github.com/apollographql/apollo-client/blob/master/src/ApolloClient.ts)を見てみる
    - `Access to fetch at 'http://localhost:30426/graphql' from origin 'http://localhost:30425' has been`
    - [CORS](https://qiita.com/sugo/items/9c5f9cc5d88e6d7efa2d#rack-cors%E3%81%AE%E5%88%A9%E7%94%A8)の設定不足っていう基本的なこと
- sampleアプリの失敗。これは動くことだけ分かればいいや。実際に失敗メモとかはこのリポジトリのアプリに書きたいからやりすぎちゃいけない
  - sampleアプリでは起動だけしてdockerアプリに入れるか判断するくらい
  - dockerアプリではビジネスロジックの関係ない技術オンリーなことを試す
  - 実際のアプリでビジネスロジックと絡んだ技術実装を試す

# 自分のアプリに入れてみて
- reduxとapolloは共存できるのか。特にreduxの`Provider`とapploの`ApolloProvider`は共存できるのか
  - ApolloProviderにstoreを入れる余地がなかったことから
  - [ここ](https://qiita.com/pokotyan/items/e71b0f0bcc1903ce4f54#%E3%82%AF%E3%83%A9%E3%82%A4%E3%82%A2%E3%83%B3%E3%83%88%E5%81%B4%E3%81%AE%E5%AE%9F%E8%A3%85)にあるように入れ子にすれば大丈夫らしい
    - この記事によるとgrqphqlを使うとreduxが必要なくなるとのこと。ものすごく期待。正確に言うとApolloClientのキャッシュとQuery,Mutateコンポーネントでのライフサイクルがreduxの代わりをする
    - `apollo-link-state`とかもあって、オライリーの本以外にデファクトスタンダードがありそうだから、一通り実装して実アプリも1個機能改修したらちょっと調べてみよう
- Queryタグはどのタイミングで最新に変わるんだろう
  - ページ再描画では最新になると思うし、n秒ごとというのも設定できた
  - でもきになるのは変更加えた後に最新になるかと言う話
  - MutationタグのrefetchQueries
- オライリーでは`ROOT_QUERY`を元にしたGraphQLのクエリ集を引き回して`<Query>`タグを使っているけど、そんなことしたらトップダウンで管理しにくくなるんじゃないか？
  - [子コンポーネントで小さくクエリ使うことできそう](https://github.com/amberbit/commentable/blob/9de79bd90ba81719146390f52bb81ffeba327f11/apps/ui/assets/js/components/CommentableWidget.js)
  - Mutationでクエリを指定してrefetchできることと合わせると
    - 1つのトップを中心としたトップダウンでなくていいことはわかったが、グローバルに定義しまくるとそれはそれで管理しにくそう。
    - まぁ、グローバルに定義して変わるべきタイミングで適切に変わるのもそれはそれでよさそうだけど。
    - Mutationで変えるのはどこかのクエリタイプに定義されたものだから、Queryしているものと共通のものを使うということで、自由といえどもMutation側は参照識別子を使ってるっぽい感じだけど
  - どうしようか
    - 取りうる方法
      - A. 関心のトップにQueryタグとGraphQLクエリを用意し、それらに関連することはその配下でのみいじる
      - B. QueryとMutationはお互い気にせず存在していい。
        - ただMutation側はQueryで使っているものを参照識別子的に使うことになる。
        - となるとQueryの扱いは`app/models`のようにデータの集合がたくさんある運用になるのか？
        - ただそうするとRESTと同じ過小のクエリが増えるからいやだ。
    - 上記の判断により組むべきディレクトリ構成が変わる。Githubのいろんなのを見てみたい
    - Bは問題含みっぽいからAのように関心のコンポーネントでディレクトリ作って、reduxのviewと~modelsがセットになっているのが使いやすいように、関心の中でviewとデータがMVCをサイクル仕組みが綺麗そうだな
    - modelsが`queries`になるイメージかな
    - viewModelsはGraphQL化は難しそう。だけどredux使って中央管理するほどでもないからローカルステートでもいい気もする。