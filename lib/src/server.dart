import 'dart:io';

import 'context.dart';
import 'controllers/controller.dart';
import 'controllers/middleware.dart';

/// Root class for server
///
/// If server cannot handle request, it sends error with code
/// `501`(not implemented) and reason to client.
class Server {
  /// Default constructor that creates simple HTTP server
  Server();

  /// Create secure instanse of [Server] with TLS/SSL connection
  /// enabled and given [SecurityContext]
  Server.secure(this._context, {this.requestClientSertificate = false});

  /// Create instance of [Server] attached to [ServerSocket]
  Server.socket(this._socket);

  /// Security context for secure connection
  SecurityContext _context;

  /// Signals if server will request client sertificate, is
  /// used when [Server] establish secure connection.
  bool requestClientSertificate;

  /// Socket that server is listening to
  ServerSocket _socket;

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
    HttpServer connection;
    if (_socket != null) {
      connection = HttpServer.listenOn(_socket);
    } else if (_context != null) {
      connection = await HttpServer.bindSecure(host, port, _context,
          requestClientCertificate: requestClientSertificate);
    } else {
      connection = await HttpServer.bind(host, port);
    }

    print('Connection was established at $host:$port');

    await for (final req in connection) {
      final ctx = Context(req);

      final _routes = _controllers.where((route) => route.hasMatch(ctx));
      if (_routes.isEmpty) {
        await ctx.sendError(
            HttpStatus.notImplemented,
            'Route isn\'t provided for path: "${ctx.uri.path}" '
            'with method: "${ctx.method}"');
      }

      if (_middlewares.isNotEmpty) {
        for (final middle in _middlewares) {
          await middle.change(ctx);
        }
      }

      for (final controller in _routes) {
        await controller.handle(ctx);
      }
    }
  }
}
