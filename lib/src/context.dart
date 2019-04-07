import 'dart:convert';
import 'dart:io';

/// Class that contains request and response objects
///
/// Also it contains most common aliases of [request] and [response]
/// objects.
class Context {
  /// Create instance of [Context] with [request]
  Context(this.request);

  /// Holds request object
  final HttpRequest request;

  /// Gets response object
  HttpResponse get response => request.response;

  /// Method of request
  String get method => request.method;

  /// Uri of request
  Uri get uri => request.uri;

  /// Gets cookies from the request
  List<Cookie> get reqCookies => request.cookies;

  /// Request headers
  HttpHeaders get reqHeaders => request.headers;

  /// Session for this request
  HttpSession get session => request.session;

  /// Response headers
  HttpHeaders get resHeaders => response.headers;

  /// Cookies to set in the client (in the 'set-cookie' header)
  List<Cookie> get resCookies => response.cookies;

  /// Field that contain request body
  ///
  /// Filled when is used `bodyParser` middleware.
  /// For `text` [reqBodyType] the type of this will be `String`,
  /// for `binary` - `List<int>`,
  /// for `json` - `Map<String, dynamic>`
  Object reqBody;

  /// Field that contain body type: `text`, `binary` or `json`. These values
  /// represents how request body was parsed
  String reqBodyType;

  /// Holds files from `static` directory (default directory for static files,
  /// you can change it in `buildStaticFilesHandler` middleware)
  ///
  /// Keys are paths of each file started from root directory of project.
  /// Example: `static/image.png`.
  final Map<String, File> staticFiles = <String, File>{};

  /// Sends [body] to client
  Future<void> send(Object body) async {
    response.write(body);
    await response.flush();
    await response.close();
  }

  /// Sends [json] to client
  Future<void> sendJson(Object json) async {
    final body = jsonEncode(json);
    resHeaders.contentType = ContentType.json;
    response.write(body);
    await response.flush();
    await response.close();
  }

  /// Unit [objects] and sends them to client
  ///
  /// If [separator] is provided then it is inserted between elements.
  Future<void> sendAll(Iterable<Object> objects,
      [String separator = '']) async {
    response.writeAll(objects, separator);
    await response.flush();
    await response.close();
  }

  /// Sends error to client if it cannot handle request
  Future<void> sendError(int code, String reason) async {
    final body = <String, String>{'error': reason};
    response.statusCode = code;
    await sendJson(body);
  }

  /// Redirects to specified location [to] with optional [status]
  Future<void> redirect(Uri to, {int status}) async {
    await response.redirect(to, status: status ?? HttpStatus.movedTemporarily);
  }
}
