import 'package:les/les.dart';

void main(List<String> args) {
  // Creates instance of [Server]
  Server()
  // Add middlewares
  ..use(bodyParser)
  ..use(buildStaticFilesHandler())
  // Add [Routes]
    ..add(routes)
    // Start listen for requests
    ..listen(7575);
}

// Define [Route]s that describe answers for concrete requests
final routes = Router('/')
  ..add(Route(
        // Path will be transformed to RegExp => (:number)
        r':a(\d+)',
        (ctx) => ctx.send('Hello get')
      ))
  ..add(Route(
      'post',
      (ctx) => ctx.send('Hello post'),
      method: HttpMethod.post
      ));
