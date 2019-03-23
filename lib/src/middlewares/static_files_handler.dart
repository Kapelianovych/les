import 'dart:io';

import '../context.dart';
import '../controllers/middleware.dart';

/// Builds static files handler for provided [path]
///
/// [path] starts from the root of project.
/// All files will store in [Context] object for current session.
///
/// Note that context will not store actual files, instead it will contain
/// [File] object with some info about actual file.
/// You must read and convert that file by yourself.
///
/// If directory isn't exist context object will have empty [Map]
/// object.
Middleware buildStaticFilesHandler([String path = 'static']) {
  final staticDir = Directory(path);
  final files = <String, File>{};

  List<FileSystemEntity> fileEntities;
  if (staticDir.existsSync()) {
    fileEntities = staticDir.listSync(recursive: true);
    for (final file in fileEntities) {
      files[file.path] = File(file.path);
    }
  }

  return Middleware((ctx) {
    ctx.files = files;
  });
}
