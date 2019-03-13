import 'package:les/les.dart';

void main(List<String> args) {
  // Creates instance of [Server]
  Server()
  // Add middlewares
  ..use(bodyParser)
  ..use(Middleware((ctx) {
    print(ctx.reqBody);
  }))
  // Add [Routes]
    ..add(routes)
    // Start listen for requests
    ..listen(7575);
}

// Define [Route]s that describe answers for concrete requests
final routes = Router('/')
  ..add(Route(
        // Path will be transformed to RegExp 
        r':a(\d+)',
        (ctx) => ctx.send('Hello get')
      ))
  ..add(Route(
      'af/af',
      (ctx) => ctx.send('Hello post'),
      method: HttpMethod.post
      ));
