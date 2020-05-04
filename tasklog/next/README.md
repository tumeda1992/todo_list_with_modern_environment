- ドキュメント
  - [日本語(翻訳中)](https://nextjs-docs-ja.netlify.app/docs)
  - [原本](https://nextjs.org/learn/basics/create-nextjs-app?utm_source=next-site&utm_medium=homepage-cta&utm_campaign=next-website)
- 感想
  - 初立ち上げ
    - 単なるnextアプリはかなりシンプル。nextとreactだけ入っていてnextコマンドを実行するのみ
    - `.next`ディレクトリで色々隠蔽してる。webpackとか
    - `api-routes-graphql`のテンプレートを入れてみたけど、`/api`で立てたGraphQLサーバに投げて受け取るやつだった
  - ポート
    - デフォルトポートは3000
    - `next dev <dir> -p <port number>`
  - `next` vs `create-react-app` どっちで始めるか
    - 
  - reactアプリとの協調
    - 既存Reactアプリ
    - 新規Reactアプリを作る時
      - create-react-appとか使わずに作ることになっちゃうかな
    - 新規Reaxt-nativeアプリを作る時

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