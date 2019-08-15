# 0.1.0

- Small changes to fix lint warnings.
- Upgrade Dart SDK to `2.2.0`.

## 0.0.5

- Add `Server.secure` constructor for establishing **HTTPS** connection and
`Server.socket` constructor for establishing connection via socket.
- Downgrade sdk to `2.1.0-dev.9.4` and some packages.
- Add `cors` middleware.
- Edit README.

## 0.0.4

- Add `session` getter to `Context` object.
- Change checking route match to specific request (non-breaking fix).
- Make all methods of `Context` object asynchronous.
- Edit README.

## 0.0.3+1

- Edit README.
- Rename `files` field of `Context` to `staticFiles`.

## 0.0.3

- Add `staticFilesHandler` middleware.
- Add `files` field to `Context` object.
- Edit README.

## 0.0.2

- Change `bodyParser` to parse body in `put`, `post`, `patch` and `delete` http methods.
- Add default error response 501 if route for request isn't provided.

## 0.0.1

- Initial version.
- Creates core of the package. See README.
