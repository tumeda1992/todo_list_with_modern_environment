import { useRouter } from 'next/router';
import Link from 'next/link';
import React from 'react';

export default () => {
  const router = useRouter()
  const { id, name, param } = router.query

  return (
    <React.Fragment>
      <p>Post({id}) : {name} (param: {param})</p>
      <Link href="/">
        home
      </Link>
    </React.Fragment>
  )
}