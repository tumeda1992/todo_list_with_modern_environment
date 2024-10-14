import React from 'react';
import Link from 'next/link';
import Head from 'next/head';

const Home = ({ content }) => {
  const pids = ['id1', 'id2', 'id3']
  return (
    <React.Fragment>
      <Head>
        <title>nextアプリ</title>
      </Head>
      <div className="container">
        {
          pids.map(pid => (
            <div key={pid}>
              <Link
                href="/post/[pid]/[name]" // 見るjsファイル
                as={`/post/${pid}/hoge?param=k`} // パス
              >
                Post {pid}
              </Link>
            </div>
          ))
        }
        indexページだぜー
      </div>
    </React.Fragment>
  )
}



export default Home