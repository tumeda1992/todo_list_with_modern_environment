- 参照ドキュメント
  - 最初は[英語ドキュメント](https://www.typescriptlang.org/docs/handbook/functions.html)を読んでたんだけど断念
    - 概略は知ってて全ドキュメントを概観したいという欲求の場合、英語で読むのは不適当。時間がかかりすぎる。こんなかけるところじゃない。
      - 初学の場合も不適当だから結局英語で読むのはスポットで少し読むくらいなんだろうな。仕方なく読む場合のみ
    - ハンドブックのところを速く概観したかったからそれを探した
  - [日本語版](http://js.studio-kingdom.com/typescript/handbook/functions)
    - 文字が小さいけど外観できるのに比べれば安いリスク。170%で観たらちょうどよかった
  - [DeepDive](https://typescript-jp.gitbook.io/deep-dive/)
- 型指定
  - nullを許容する場合
    - `str string | null`
- interface
  - パスカルケース（単語先頭大文字）で書く
  - 関数に使う場合：引数と返り値の型指定
    - Reactコンポーネントではそれをpropsと呼ぶ
  - クラスに使う場合：フィールドの型指定とメソッドの型と返り値指定
  - ?でオプショナルなものも定義できる
  - interfaceも継承できる
- [type](http://js.studio-kingdom.com/typescript/handbook/advanced_types)
  - `type`は型のエイリアス。型情報を変数に入れるっぽくできる
  - 複数の型定義を組み合わせられる。IntersectionTypes交差型(`Hoge & Fuga`)とUnionType(`Hoge | Fuga`)
  - 単体の型定義をする`type`は[ほとんどinterfaceと同様に使うことができる](http://js.studio-kingdom.com/typescript/handbook/advanced_types)が、typeの方が貧弱[参考(インターフェース vs 型のエイリアス)](http://js.studio-kingdom.com/typescript/handbook/advanced_types)
    - インターフェースはどこにでも使用できる新しい名前を作り出すことです。 型のエイリアスはインスタンスのために新しい名前を作成せず、エラーメッセージにはそのエイリアス名は使用されません。
    - 型のエイリアスは拡張や実装が出来ないということです
    - あなたは可能な限り、型のエイリアスよりもインターフェースを使用するべきでしょう。
- [ジェネリクス](http://js.studio-kingdom.com/typescript/handbook/generics)
  - ジェネリクスが定義できる場合で、明示的に指定しなくても引数から勝手に推論してくれる
  - ジェネリクス使った上でlengthとかある型にしかないフィールドやメソッドにアクセスできるようにするには`<T extends Lengthable>` `interface Lengthable {length: number}`と書く([参考(ジェネリクスの制約)](http://js.studio-kingdom.com/typescript/handbook/generics))
- [モジュール(Ambient Modules欄)](http://js.studio-kingdom.com/typescript/handbook/modules)
  - これは別にtypescriptではなくnodeの機能だけど。
  - `import React from 'react';`のような呼び方をするためのやつ。
  - アプリ内でこのように呼べるものを1つの巨大な.d.tsファイルにそれらを書く
    - そのファイルは`tsconfig.json`でimportする
- Tips
  - テーマつけられないけど大事だからメモしたいやつ
  - 一応な知識
    - 一応工夫すればオーバーロードできる([参考](http://js.studio-kingdom.com/typescript/handbook/functions))
- React
  - 基本的にpropTypesは型interfaceで肩代わりできる
    - [ただライブラリ公開とかして、jsとかts以外でtsコンポーネントを触るときには制約として便利](https://qiita.com/HiroshiAkutsu/items/1528927165f750c37ce0)
  - 基本的な型定義
    - [関数コンポーネント](https://typescript-jp.gitbook.io/deep-dive/tsx/react#konpnentofunctional-components)
    - [クラスコンポーネント](https://typescript-jp.gitbook.io/deep-dive/tsx/react#kurasukonpnentoclass-components)
  - [CreateReactAppにTypeScriptを適用](https://qiita.com/namaozi/items/7446804126a055caf254)
    - typescriptプロジェクトを作る場合、`yarn create react-app my-app --template typescript`

20200503
ドキュメント読んで、少しコード書いたくらいで、60点くらいとれた感じ。
あとは使いながら慣れていく。仕事で使うコードもこれでよめそうだし

# 参考コード
## enumにどんな値が入るか
```ts
  enum Directions {
    Up = 4,
    Down,
    Left,
    Right
  }
  let directions = [Directions.Up, Directions.Down, Directions.Left, Directions.Right]
  console.log('directions', directions) // 4,5,6,7
```

## typeとinterface
```ts
  interface Hoge { hogeField: string }
  interface Fuga { fugaField: string }
  const fuga = (arg: Hoge & Fuga): string => {return arg.fugaField}
  const fugaVal = fuga(({hogeField: "hooge", fugaField: "fuuga"}))
  console.log('fugaVal', fugaVal)
  type HogeFuga = Hoge & Fuga
  const hogefuga = (arg: Hoge & Fuga): string => {return arg.fugaField}
```

## モジュールの定義
```ts
// hoge.d.ts
declare module "url" {
    export interface Url {
        protocol?: string;
        hostname?: string;
        pathname?: string;
    }
    export function parse(urlStr: string, parseQueryString?, slashesDenoteHost?): Url;
}

// hoge.ts
import url from 'url';
```