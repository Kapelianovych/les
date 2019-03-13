import 'package:les/les.dart';

void main() {
  Server()
  ..use(bodyParser)
  ..use(Middleware((ctx) {
    print(ctx.reqBody);
  }))
    ..add(routes)
    ..listen(7575);
}

final routes = Router('/')
  ..add(Route(
        r':a(\d+)',
        (ctx) => ctx.send('Hello get')
      ))
  ..add(Route(
      'af/af',
      (ctx) => ctx.send('Hello post'),
      method: HttpMethod.post
      ));