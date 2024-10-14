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
        apiコンテンツ: {content}
      </div>
    </React.Fragment>
  )
}

// contextはreqとか入ってる https://nextjs.org/docs/basic-features/data-fetching#getserversideprops-server-side-rendering
// Home.getInitialProps = async ({ req }) =>  {
// const getStaticProp = async ({ req }) =>  {
const getServerSideProps = async ({ context }) =>  {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_API_ORIGIN}/hello`)
  const json = await res.json()
  return { props: { content: json.content } }
}
export { getServerSideProps }

export default Home