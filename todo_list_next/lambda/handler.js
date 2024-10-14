// 公式でやるのうまくいかないから諦めた
const next = require('next');

const app = next({
    dev: false,
    conf: {},
    dir: './'
});
const handler = app.getRequestHandler();

exports.handler = async (event) => {
    await app.prepare();  // Next.jsの初期化

    const { rawPath, httpMethod, headers, queryStringParameters, body } = event;

    const request = {
        url: rawPath,
        method: httpMethod,
        headers,
        body,
        query: queryStringParameters,
    };

    return new Promise((resolve) => {
        const response = {
            statusCode: 200,
            headers: {},
            body: '',
            setHeader: (name, value) => (response.headers[name] = value),
            write: (chunk) => (response.body += chunk),
            end: () => resolve(response),
        };

        handler(request, response);
    });
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
