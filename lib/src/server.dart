import 'dart:io';

import 'context.dart';
import 'controllers/controller.dart';
import 'controllers/middleware.dart';

/// Root class for server
///
/// If server cannot handle request, it sends error with code
/// `404` and reason to client.
class Server {
  /// Internal storage of custom end controllers
  final List<Controller> _controllers = <Controller>[];

  /// Internal storage of middlewares
  final List<Middleware> _middlewares = <Middleware>[];

  /// Register middleware
  void use(Middleware middleware) {
    _middlewares.add(middleware);
  }

  /// Register list of middlewares
  void useAll(List<Middleware> middleware) {
    _middlewares.addAll(middleware);
  }

  /// Register end controller
  void add(Controller controller) {
    _controllers.add(controller);
  }

  /// Listen for requests at [port] and [host]
  ///
  /// If `Route` isn't provided for `path` and `method`, error message will be
  /// sent to the client.
  Future<void> listen(int port, {String host = '127.0.0.1'}) async {
    final connection = await HttpServer.bind(host, port);
    print('Connection was established at $host:$port');

    await for (final req in connection) {
      final ctx = Context(req);

      final hasMatch = _controllers.any((r) => r.hasMatch(ctx));
      if (!hasMatch) {
        ctx.sendError(HttpStatus.notImplemented,
            'Route isn\'t privided for path: ${ctx.uri.path}');
      }

      if (_middlewares.isNotEmpty) {
        for (final middle in _middlewares) {
          await middle.change(ctx);
        }
      }

      for (final controller in _controllers) {
        await controller.handle(ctx);
      }
    }
  }
}
