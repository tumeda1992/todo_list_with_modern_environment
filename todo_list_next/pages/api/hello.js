// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

import logAccess from "../../utils/logAccess";

export default (req, res) => {
  logAccess(req)

  res.statusCode = 200
  res.json({ name: 'John Doe' })
}
