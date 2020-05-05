# ドキュメント
https://nodejs.org/en/docs/guides/getting-started-guide/

# 感想
- [チュートリアルの最初](https://nodejs.org/en/docs/guides/getting-started-guide/)を見て、あまりにも簡単にサーバを立ち上げられてびっくりした
- `yarn add`とかのときの`fs`ってファイル操作ライブラリだったんだ


# package.json
ライブラリみるときに慣れで`src`を見たり`packages`を見てるけど、なぜそれを見るのがいいのか知りたい。

## 既存のライブラリを見る（redux-formを例に）
https://github.com/redux-form/redux-form/blob/master/package.json
```
{
  "name": "redux-form",
  "version": "8.3.5",
  "description": "A higher order component decorator for forms using Redux and React",
  "main": "./lib/index.js",
  "module": "./es/index.js",
  "modules.root": "./es",
  "jsnext:main": "./es/index.js",
  ...
```

### リポジトリのディレクトリ構成
https://github.com/redux-form/redux-form
```sh
~/src/libraries/redux-form user 15:24:10
$ ls
scripts
docs
src
flow-typed
package-lock.json
tools.md
package.json
webpack.config.js
...
```

### node_moduleでビルドされた結果のディレクトリ構成
```sh
path/to/dir/node_modules/redux-form user 15:17:27
$ ls
CHANGELOG.md	README.md	es		lib		package.json
LICENSE		dist		immutable.js	node_modules
```

## 所感
- 調査前にはpackage.jsonを見ればいいと思ってたけど、`src`とかに置いているのはwebpack。nodeを知るというよりはwebpackを知ることが必要だったんだ。
  - [webpackの起点はsrc/index.js](https://webpack.js.org/configuration/)
- 確かにnode_modulesを見るとpackage.jsonに書いてある配置で置いてある。package.jsonはビルド後の情報
- webpackを知るかというとnextとかがいい感じに隠蔽しているから必要になったタイミングで見よう。
- ライブラリを作ろうと思ったけど理解できたからいいや。今度作るときpackage.jsonもwebpackも見よう
