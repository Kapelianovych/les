import 'package:http_server/http_server.dart';

import '../context.dart';
import '../controllers/middleware.dart';

Future<void> _bodyParser(Context ctx) async {
  final body = await HttpBodyHandler.processRequest(ctx.request);
  ctx
    ..reqBody = body.body
    ..reqBodyType = body.type;
}

/// Middleware that parse body of request if it exists
final Middleware bodyParser = Middleware(_bodyParser);
