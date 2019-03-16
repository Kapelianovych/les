import 'package:http_server/http_server.dart';

import '../constants/http_methods.dart';
import '../context.dart';
import '../controllers/middleware.dart';

Future<void> _bodyParser(Context ctx) async {
  if (ctx.method == HttpMethod.post ||
      ctx.method == HttpMethod.put ||
      ctx.method == HttpMethod.patch ||
      ctx.method == HttpMethod.delete) {
    final body = await HttpBodyHandler.processRequest(ctx.request);
    ctx
      ..reqBody = body.body
      ..reqBodyType = body.type;
  }
}

/// Middleware that parse body of request if it exists,
/// otherwise returns `null`
final Middleware bodyParser = Middleware(_bodyParser);
