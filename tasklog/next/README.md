- ドキュメント
  - [日本語(翻訳中)](https://nextjs-docs-ja.netlify.app/docs)
  - [原本](https://nextjs.org/learn/basics/create-nextjs-app?utm_source=next-site&utm_medium=homepage-cta&utm_campaign=next-website)
- 感想
  - 初立ち上げ
    - 単なるnextアプリはかなりシンプル。nextとreactだけ入っていてnextコマンドを実行するのみ
    - ~~`.next`ディレクトリで色々隠蔽してる。webpackとか~~ `.next`はbuild結果
    - `api-routes-graphql`のテンプレートを入れてみたけど、`/api`で立てたGraphQLサーバに投げて受け取るやつだった
  - ポート
    - デフォルトポートは3000
    - `next dev <dir> -p <port number>`
  - 基本機能
    - we recommend that you use getStaticProps or getServerSideProps instead of getInitialProps.([参考](https://nextjs.org/docs/api-reference/data-fetching/getInitialProps))
    - [routing](https://nextjs-docs-ja.netlify.app/docs#intercepting-popstate)
    - `./pages/_app.js` -> [カスタムApp](https://nextjs.org/docs/advanced-features/custom-app)
    - ベースHTML -> [カスタムドキュメント](https://nextjs.org/docs/advanced-features/custom-document)
    - [next.config.js](https://nextjs.org/docs/api-reference/next.config.js/introduction)
      - [環境変数の定義](https://nextjs.org/docs/api-reference/next.config.js/environment-variables) -> `process.env.hogeKey`で取得
      - [拡張webpack設定](https://nextjs.org/docs/api-reference/next.config.js/custom-webpack-config)
  - `next` vs `create-react-app` どっちで始めるか
    - SPAで始めるならルーティング必須だからnext一択。create-react-appは初学者が動かすにはいいけど、webpackとか自分がいじらないのに公開されているものばかりだから。
    - よほど凝った既存アプリならnext入れてnextの仕様に合わせてあげてnext化するのもいいけど、通信とか書き直すくらいなら作り直しても同じかと思う。
  - typescript
    - [紹介ドキュメント](https://nextjs.org/docs/basic-features/typescript)
    - [Qiita](https://qiita.com/ryo511/items/d2cfc70ab29618e8852b)
  - GraphQL
    - apolloを使わないGraphQLから取ってくるのはexampleにある(参考：graphqlクライアント例欄)
    - けどやってることは関数コンポーネントの中でデータ取ってきてるからApolloでも変わらないな
    - てっきり`getServerSideProps`とか使うと思ってた。SSRで初回取得だけサーバサイド側でやるってだけなのかな？
    - まぁやってみて試すか
    - [ここ](https://qiita.com/mizchi/items/c078aea032cd00ba3e86#graphql-%E3%82%AF%E3%83%A9%E3%82%A4%E3%82%A2%E3%83%B3%E3%83%88%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B)で紹介されてる[with-apolloのnextプロジェクトのexample](https://github.com/zeit/next.js/tree/master/examples/with-apollo)使えばいけそう。ssr
    - `serversideCount += 1;console.log("serverside process", serversideCount);`おいたらサーバーサイドで3回、クライアントで2回ログが吐かれた。
      - ssl_mode=falseだったらサーバサイドで1回、クライアントサイドで2回。サーバーサイドの1回っていうのは回遊で多分それ以外の2っていうのは開始時のloading=trueのときだろうな。
      - 実質nextでapollo入れてもクライアント側でGraphQLで読んじゃってる。DOMContentLoadedとLoadの時間があまり変わんないから実装者の好みなんだろうな。
  - ReactNativeWeb
    - [example](https://github.com/zeit/next.js/tree/master/examples/with-react-native-web)
  - nextに限らないけど
    - `yarn install sass`で`module.scss`とかを使ったスタイリングができる

# 参考コード
## シンプルnextアプリのpackage.json
```json
{
  "name": "hogehoge",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "9.3.6",
    "react": "16.13.1",
    "react-dom": "16.13.1"
  }
}

```

## graphqlクライアント例
```js
import useSWR from 'swr'

const fetcher = query =>
  fetch('/api/graphql', {
    method: 'POST',
    headers: {
      'Content-type': 'application/json',
    },
    body: JSON.stringify({ query }),
  })
    .then(res => res.json())
    .then(json => json.data)

export default function Index() {
  const { data, error } = useSWR('{ users { name } }', fetcher)

  if (error) return <div>Failed to load</div>
  if (!data) return <div>Loading...</div>

  const { users } = data

  return (
    <div>
      {users.map((user, i) => (
        <div key={i}>{user.name} hogehoge</div>
      ))}
    </div>
  )
}
```