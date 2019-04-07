import '../context.dart';
import 'controller.dart';
import 'middleware.dart';
import 'route.dart';

/// Class that define multiple [Route]s for [rootPath] and its
/// derivated
class Router extends Controller {
  /// Creates [Router] with [rootPath] and optionally predefined [routes]
  /// and [middlewares]
  ///
  /// [middlewares] is executed before each [Route] of this [Router].
  /// For executing middleware before specific route, create [Route]
  /// with middleware.
  Router(this.rootPath, {List<Route> routes, List<Middleware> middlewares}) {
    _routes.addAll(routes ?? <Route>[]);
    _middlewares.addAll(middlewares ?? <Middleware>[]);
  }

  /// Holds root path for all [Route]s
  final String rootPath;

  /// Holds all routes in order that they added
  final List<Route> _routes = <Route>[];

  /// Holds middlewares that will be executed bofore aech [Route]
  final List<Middleware> _middlewares = <Middleware>[];

  /// Add [Route] to [Router]
  void add(Route route) {
    route.path = rootPath + route.path;
    _routes.add(route);
  }

  /// Add list of [Route] to [Router]
  void addAll(List<Route> list) => _routes.addAll(list);

  @override
  Future<void> handle(Context ctx) async {
    if (_middlewares.isNotEmpty) {
      for (final middle in _middlewares) {
        await middle.change(ctx);
      }
    }

    for (final route in _routes) {
      await route.handle(ctx);
    }
  }

  @override
  bool hasMatch(Context ctx) => _routes.any((route) => route.hasMatch(ctx));
}
