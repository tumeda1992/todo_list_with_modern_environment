const { createServer } = require('http');
const next = require('next');

// 本番モード (dev: false)
const app = next({ dev: false });
const handler = app.getRequestHandler();

// サーバの起動とリクエスト処理
app.prepare().then(() => {
    const server = createServer((req, res) => {
        console.log(`Received request: ${req.url}`);
        console.log(`Request headers(before_modify):`, req.headers);

        res.setHeader('Access-Control-Allow-Origin', '*'); // ソース側で必要か不明（Lambdaの設定では必要）
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
        res.setHeader('Content-Type', 'text/html');
        console.log(`Request headers(after_modify):`, req.headers);

        handler(req, res)
            .then(() => {
                console.log(`Successfully served: ${req.url}`);
            })
            .catch((err) => {
            console.error('Error occurred handling request', req.url, err);
            res.statusCode = 500;
            res.end('Internal Server Error(error in js response)');
        });
    });

    const port = process.env.PORT || 8080;
    server.listen(port, (err) => {
        if (err) throw err;
        console.log(`> Ready on http://localhost:${port}`);
    });
});
