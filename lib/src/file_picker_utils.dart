import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import 'platform_file.dart';

Future<List<PlatformFile>> filePathsToPlatformFiles(
  List<String> filePaths,
  bool withReadStream,
  bool withData,
) {
  return Future.wait(
    filePaths
        .where((String filePath) => filePath.isNotEmpty)
        .map((String filePath) async {
      final file = File(filePath);

      if (withReadStream) {
        return createPlatformFile(file, null, file.openRead());
      }

      if (!withData) {
        return createPlatformFile(file, null, null);
      }

      final bytes = await file.readAsBytes();
      return createPlatformFile(file, bytes, null);
    }).toList(),
  );
}

Future<PlatformFile> createPlatformFile(
  File file,
  Uint8List? bytes,
  Stream<List<int>>? readStream,
) async =>
    PlatformFile(
      bytes: bytes,
      name: p.basename(file.path),
      path: file.path,
      readStream: readStream,
      size: await file.length(),
    );
