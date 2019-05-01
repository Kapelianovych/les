import 'package:les/les.dart';

void main() {
  Server()
  ..use(bodyParser)
  //..use(cors())
    ..add(routes)
    ..listen(7575);
}

final routes = Router('/')
  ..add(Route(
        r':a(\d+)',
        (ctx) async {
          await ctx.send(ctx.staticFiles['static/image.png'].readAsBytesSync());
        }
      ))
  ..add(Route(
      'af',
      (ctx) => ctx.send('Hello post'),
      method: HttpMethod.delete
      ));