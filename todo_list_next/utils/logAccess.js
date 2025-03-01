export default function logAccess(req) {
  const { headers, url } = req;
  const { host } = headers;
  console.log(`ホスト: ${host}, パス: ${url}`)
}
