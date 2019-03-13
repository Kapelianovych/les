/// Class that contains http request methods
///
/// [HttpMethod] have predefined common methods as static constants,
/// but also you can define your own by creating instanse
/// of [HttpMethod]
class HttpMethod {
  /// Create instance of [HttpMethod] with custom method([self])
  const HttpMethod(this.self);

  /// GET method
  static const String get = 'GET';

  /// POST method
  static const String post = 'POST';

  /// PUT method
  static const String put = 'PUT';

  /// DELETE method
  static const String delete = 'DELETE';

  /// HEAD method
  static const String head = 'HEAD';

  /// PATCH method
  static const String patch = 'PATCH';

  /// OPTIONS method
  static const String options = 'OPTIONS';

  /// CONNECT method
  static const String connect = 'CONNECT';

  /// TRACE method
  static const String trace = 'TRACE';

  /// Holds custom method
  final String self;
}
