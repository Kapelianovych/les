import '../controllers/middleware.dart';

/// Configures CORS with given [options]
///
/// By default if [options] isn't provided response
/// gets such headers:
/// ```json
/// {
///   "Access-Control-Allow-Origin": "*",
///   "Access-Control-Allow-Methods": "GET,HEAD,PUT,PATCH,POST,DELETE",
///   "Access-Control-Allow-Credentials": "false"
/// }
/// ```
///
/// The full list of [options] keys:
///```json
///   "Access-Control-Allow-Origin": "http://localhost:7864",
///   "Access-Control-Allow-Methods": "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
///   "Access-Control-Allow-Credentials": "true",
///   "Access-Control-Allow-Headers": "Content-Type",
///   "Access-Control-Expose-Headers": "X-My-Custom-Header"
///   "Access-Control-Max-Age": "86400"
///```
///
/// More info at [MDN](https://developer.mozilla.org/uk/docs/Web/HTTP/CORS).
Middleware cors([Map<String, String> options]) {
  final headers = <String, String>{};
  if (options != null) {
    headers.addAll(options);
  } else {
    headers.addAll(<String, String>{
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET,HEAD,PUT,PATCH,POST,DELETE',
      'Access-Control-Allow-Credentials': 'false'
    });
  }

  return Middleware((ctx) {
    headers.forEach((key, value) => ctx.resHeaders.add(key, value));
  });
}
