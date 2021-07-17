import 'package:file_picker_desktop/src/platform_file.dart';

import 'file_picker.dart';
import 'file_picker_result.dart';
import 'file_picker_utils.dart';
import 'file_type.dart';

class FilePickerMacOS extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    required String dialogTitle,
    required FileType type,
    List<String>? allowedExtensions,
    required bool allowMultiple,
    required bool withData,
    required bool withReadStream,
  }) async {
    final String executable = await isExecutableOnPath('osascript');
    final String fileFilter = fileTypeToFileFilter(
      type,
      allowedExtensions,
    );
    final List<String> arguments = generateCommandLineArguments(
      dialogTitle,
      fileFilter: fileFilter,
      multipleFiles: allowMultiple,
      pickDirectory: false,
    );

    final String? fileSelectionResult = await runExecutableWithArguments(
      executable,
      arguments,
    );
    if (fileSelectionResult == null) {
      return null;
    }

    final List<String> filePaths = resultStringToFilePaths(
      fileSelectionResult,
    );
    final List<PlatformFile> platformFiles = await filePathsToPlatformFiles(
      filePaths,
      withReadStream,
      withData,
    );

    return FilePickerResult(platformFiles);
  }

  @override
  Future<String?> getDirectoryPath({
    required String dialogTitle,
  }) async {
    final String executable = await isExecutableOnPath('osascript');
    final List<String> arguments = generateCommandLineArguments(
      dialogTitle,
      pickDirectory: true,
    );

    final String? directorySelectionResult = await runExecutableWithArguments(
      executable,
      arguments,
    );
    if (directorySelectionResult == null) {
      return null;
    }

    return resultStringToFilePaths(directorySelectionResult).first;
  }

  String fileTypeToFileFilter(FileType type, List<String>? allowedExtensions) {
    switch (type) {
      case FileType.any:
        return '';
      case FileType.audio:
        return '"mp3", "wav", "midi", "ogg", "aac"';
      case FileType.custom:
        return '"' + allowedExtensions!.join('", "') + '"';
      case FileType.image:
        return '"jpg", "jpeg", "bmp", "gif", "png"';
      case FileType.media:
        return '"webm", "mpeg", "mkv", "mp4", "avi", "mov", "flv", "jpg", "jpeg", "bmp", "gif", "png"';
      case FileType.video:
        return '"webm", "mpeg", "mkv", "mp4", "avi", "mov", "flv"';
      default:
        throw Exception('unknown file type');
    }
  }

  List<String> generateCommandLineArguments(
    String dialogTitle, {
    String fileFilter = '',
    bool multipleFiles = false,
    bool pickDirectory = false,
  }) {
    final arguments = ['-e'];

    String argument = 'choose ';
    if (pickDirectory) {
      argument += 'folder ';
    } else {
      argument += 'file of type {$fileFilter} ';

      if (multipleFiles) {
        argument += 'with multiple selections allowed ';
      }
    }

    argument += 'with prompt "$dialogTitle"';
    arguments.add(argument);

    return arguments;
  }

  /// Transforms the result string (stdout) of `osascript` into a [List] of
  /// file paths.
  List<String> resultStringToFilePaths(String fileSelectionResult) {
    if (fileSelectionResult.trim().isEmpty) {
      return [];
    }
    return fileSelectionResult
        .trim()
        .split(', ')
        .map((String path) => path.trim())
        .where((String path) => path.isNotEmpty)
        .map((String path) => '/' + path.split(':').sublist(1).join('/'))
        .toList();
  }
}
