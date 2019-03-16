# Light Efficient Server - for creating servers on Dart. Inspired by ExpressJS and Koa

Created under a MIT-style
[license](https://github.com/YevhenKap/les/blob/master/LICENSE).

## Overview

The server builds by creating instance of `Server` class. It have few methods for adding `Middleware`s and `Route`s to handling incoming requests.

```dart
Server()
    ..use(...) // Add middlewares
    ..add(...) // Add routes
    ..listen(2000); // Start listen to requests
```

### Route

One of the main concept of library is `Route` class that  describes the response for a particular path.
Its just accept path, method of the request and function that describe how to create response for such request.

```dart
Route(
    '/',
    (Context ctx) => ctx.send('Hello world'),
    method: HttpMethod.get // default. No need to be provided
);
```

If exist many routes that starts with the same path prefix, then you can provide a `Router`. Its just a collection of `Route`s for paths that start with identical prefix.

```dart
// Define [Route]s that describe answers for concrete requests
final routeOne = Route(
        r'/:a(\d+)', // Will match /5, /83645, but not /word or other symbols
        (ctx) => ctx.send('Hello get')
      );
final routeTwo = Route(
      '/b',
      (ctx) => ctx.send('Hello post'),
      method: HttpMethod.post
      )
final routes = Router('/identical');
  ..addAll(<Route>[routeOne, routeTwo]);
```

### Middleware

`Middleware` is like a `Route` controller, except that it isn't sends responses to client, but just process request before routes does. It is useful for processing some work before sending a response. **Middleware must not sends a response to the client!**

```dart
Middleware(
    (Context ctx) => // do come work over ctx object
);
```

Middlewares can be provided before each route in `Server`, before group of routes in `Router` or before specific `Route`.

### Context

The other main concept of this library is `Context` class. It contains the request object and build a response object. Handlers of `Route` and `Middleware` receive this object. It has various convinient methods for sending a responses and properties for reding request details or construct response (headers, ...) For details about methods and properties see `dartdoc`.

All path that defines in `Route` of `Router` transforms to `RegExp` and parses by [path_to_regexp](https://pub.dartlang.org/packages/path_to_regexp) package. For more info about constructing and managing paths see its documentation. Thanks to this you can provide parameter variable in path and sets to it some bounds.

### Predefined middlewares

- **bodyParser**: with library ships `bodyParser` middleware that process context object and parses its body if it exists. The content body is parsed, depending on the `Content-Type` header field. When the full body is read and parsed the body content is made available.

The following content types are recognized:

- text/*
- application/json
- application/x-www-form-urlencoded
- multipart/form-data

For content type `text/*` the body is decoded into a `String`. The 'charset' parameter of the content type specifies the encoding used for decoding. If no 'charset' is present the default encoding of ISO-8859-1 is used.

For content type `application/json` the body is decoded into a string which is then parsed as JSON. The resulting body is a `Map`. The 'charset' parameter of the content type specifies the encoding used for decoding. If no 'charset' is present the default encoding of UTF-8 is used.

For content type `application/x-www-form-urlencoded` the body is a query string which is then split according to the rules for splitting a query string. The resulting body is a `Map<String, String>`. If the same name is present several times in the query string, then the last value seen for this name will be in the resulting map. The encoding US-ASCII is always used for decoding the body.

For content `type multipart/form-data` the body is parsed into it's different fields. The resulting body is a `Map<String, dynamic>`, where the value is a `String` for normal fields and a `HttpBodyFileUpload` instance for file upload fields. If the same name is present several times, then the last value seen for this name will be in the resulting map.

When using content type `multipart/form-data` the encoding of fields with String values is determined by the browser sending the HTTP request with the form data. The encoding is specified either by the attribute `accept-charset` on the HTML form, or by the content type of the web page containing the form. If the HTML form has an `accept-charset` attribute the browser will use the encoding specified there. If the HTML form has no `accept-charset` attribute the browser determines the encoding from the content type of the web page containing the form. Using a content type of `text/html; charset=utf-8` for the page and setting `accept-charset` on the HTML form to utf-8 is recommended as the default for `HttpBodyHandler` is UTF-8. It is important to get these encoding values right, as the actual `multipart/form-data` HTTP request sent by the browser does not contain any information on the encoding.

For all other content types the body will be treated as uninterpreted binary data. The resulting body will be of type `List<int>`.

```dart
Server()
    ..use(bodyParser) // Add bodyPaarser
    ..use(...) // Add middlewares
    ..add(...) // Add routes
    ..listen(2000); // Start listen to requests
```

## Usage

See [example.](example/example.dart)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/YevhenKap/les/issues
