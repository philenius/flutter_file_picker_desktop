import 'dart:io';
import 'dart:async';
import 'package:file_picker_desktop/src/file_picker_utils.dart';

import 'file_picker.dart';
import 'file_picker_result.dart';
import 'file_type.dart';
import 'platform_file.dart';

class FilePickerLinux extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    required String dialogTitle,
    required FileType type,
    List<String>? allowedExtensions,
    required bool allowMultiple,
    required bool withData,
    required bool withReadStream,
  }) async {
    if (type != FileType.custom && (allowedExtensions?.isNotEmpty ?? false)) {
      throw ArgumentError(
          'You are setting a type [$type]. Custom extension filters are only allowed with FileType.custom, please change it or remove filters.');
    } else if (type == FileType.custom &&
        (allowedExtensions?.isEmpty ?? true)) {
      throw ArgumentError(
        'If you are setting the file type to "custom", then a non-empty list of allowed file extensions must be provided.',
      );
    }

    final String fileFilter = fileTypeToFileFilter(type, allowedExtensions);
    final String pathToExecutable = await _getPathToExecutable();
    final String? fileSelectionResult = await _openFileSelectionDialog(
      pathToExecutable,
      dialogTitle,
      fileFilter: fileFilter,
      multipleFiles: allowMultiple,
      pickDirectory: false,
    );

    if (fileSelectionResult == null) {
      return null;
    }

    final platformFiles = await resultStringToPlatformFiles(
      fileSelectionResult,
      withData,
      withReadStream,
    );

    return FilePickerResult(platformFiles);
  }

  @override
  Future<String?> getDirectoryPath({
    required String dialogTitle,
  }) async {
    final executable = await this._getPathToExecutable();
    return await _openFileSelectionDialog(
      executable,
      dialogTitle,
      pickDirectory: true,
    );
  }

  /// Returns the path to the executables `qarma` or `zenity` as a [String].
  ///
  /// On Linux, the CLI tools `qarma` or `zenity` can be used to open a native
  /// file picker dialog. It seems as if all Linux distributions have at least
  /// one of these two tools pre-installed (on Ubuntu `zenity` is pre-installed).
  /// The future returns an error, if neither of both executables was found on
  /// the path.
  Future<String> _getPathToExecutable() async {
    try {
      return await _isExecutableOnPath('qarma');
    } on Exception {
      return await _isExecutableOnPath('zenity');
    }
  }

  Future<String> _isExecutableOnPath(String executable) async {
    final processResult = await Process.run('which', [executable]);
    final path = processResult.stdout?.toString().trim();
    if (processResult.exitCode != 0 || path == null || path.isEmpty) {
      throw Exception(
        'Couldn\'t find the executable $executable in the path.',
      );
    }
    return path;
  }

  String fileTypeToFileFilter(FileType type, List<String>? allowedExtensions) {
    switch (type) {
      case FileType.any:
        return '*.*';
      case FileType.audio:
        return '*.mp3 *.wav *.midi *.ogg *.aac';
      case FileType.custom:
        return '*.' + allowedExtensions!.join(' *.');
      case FileType.image:
        return '*.png *.jpg *.jpeg';
      case FileType.media:
        return '*.png *.jpg *.jpeg *.webm *.mpeg *.mkv *.mp4 *.avi *.mov *.flv';
      case FileType.video:
        return '*.webm *.mpeg *.mkv *.mp4 *.avi *.mov *.flv';
      default:
        throw Exception('unknown file type');
    }
  }

  Future<String?> _openFileSelectionDialog(
    String executable,
    String dialogTitle, {
    String fileFilter = '',
    bool multipleFiles = false,
    bool pickDirectory = false,
  }) async {
    final arguments = ['--file-selection', '--title', dialogTitle];

    if (fileFilter.isNotEmpty) {
      arguments.add('--file-filter=$fileFilter');
    }

    if (multipleFiles) {
      arguments.add('--multiple');
    }

    if (pickDirectory) {
      arguments.add('--directory');
    }

    final processResult = await Process.run(executable, arguments);

    final path = processResult.stdout?.toString().trim();
    if (processResult.exitCode != 0 || path == null || path.isEmpty) {
      return null;
    }
    return path;
  }

  /// Transforms the result string (stdout) of `qarma` / `zenity` into a [List]
  /// of [PlatformFile]s.
  Future<List<PlatformFile>> resultStringToPlatformFiles(
    String fileSelectionResult,
    bool withData,
    bool withReadStream,
  ) {
    final filePaths = fileSelectionResult.split('|');
    return filePathsToPlatformFiles(filePaths, withReadStream, withData);
  }
}
