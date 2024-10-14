const next = require('next');
const http = require('http');

const app = next({ dev: false });
const handle = app.getRequestHandler();

exports.handler = async (event) => {
    console.log('Received event:', JSON.stringify(event, null, 2)); // デバッグログ

    const { rawPath, httpMethod, headers, body } = event;

    if (rawPath === '/api/hello' && httpMethod === 'GET') {
        return {
            statusCode: 200,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: 'John Doe' }),
        };
    } else {
        return {
            statusCode: 400,
            body: 'Invalid request',
        };
    }
};

// デバッグ方法
// curl -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" \
//   -H "Content-Type: application/json" \
//   -d '{
// "rawPath": "/api/hello",
//     "httpMethod": "GET",
//     "headers": {
//     "Content-Type": "application/json"
// }
// }'
