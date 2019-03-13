import 'package:path_to_regexp/path_to_regexp.dart';

import '../constants/http_methods.dart';
import '../context.dart';
import '../typedefs.dart';
import 'controller.dart';
import 'middleware.dart';

/// Class that describe route that must be handled
class Route extends Controller {
  /// Creates [Route] with [path] relative to corresponding [handler]
  /// and [method] of request that defaults to `GET`
  ///
  /// You can provide [middlewares] that will be executed
  /// bofore handling this route.
  Route(this.path, this.handler,
      {this.method = HttpMethod.get, List<Middleware> middlewares}) {
    _middlewares.addAll(middlewares ?? <Middleware>[]);
  }

  /// Holds path that must be handled
  String path;

  /// Handler for [path]
  final RouteHandler handler;

  /// Holds middlewares for this [Route]
  final List<Middleware> _middlewares = <Middleware>[];

  /// Method to be handled
  final String method;

  @override
  Future<void> handle(Context ctx) async {
    if (hasMatch(ctx)) {
      if (_middlewares.isNotEmpty) {
        for (final middle in _middlewares) {
          await middle.change(ctx);
        }
      }

      await handler(ctx);
    }
  }

  @override
  bool hasMatch(Context ctx) =>
      pathToRegExp(path).hasMatch(ctx.uri.path) && ctx.method == method;
}
