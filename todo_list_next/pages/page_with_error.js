export default ({ content }) => {
  return (
    <div className="container">
        aaa{content}
    </div>
  )
}

const getServerSideProps = async (req, res) => {
  throw new Error('Intentional Server-Side Error');
  return { props: { content: 1 / 0 } }
}

export { getServerSideProps }