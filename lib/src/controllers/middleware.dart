import '../context.dart';
import '../typedefs.dart';

/// Class that process context object before each route
class Middleware {
  /// Register [changer]
  Middleware(this.changer);

  /// Holds [changer] of context
  final RouteHandler changer;

  /// Change [ctx] with [changer]
  Future<void> change(Context ctx) async {
    await changer(ctx);
  }
}
