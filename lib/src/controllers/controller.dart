import '../context.dart';
import '../typedefs.dart';

/// Base class that describe end request handling
abstract class Controller {
  /// Invokes [RouteHandler] with current context
  Future<void> handle(Context ctx);

  /// Check if this controller matches with context
  bool hasMatch(Context ctx);
}
