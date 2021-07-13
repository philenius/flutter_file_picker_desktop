/*
This code has been copied with minor modifications from:
https://github.com/miguelpruivo/flutter_file_picker

MIT License

Copyright (c) 2018 Miguel Ruivo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'dart:io';

import 'package:file_picker_desktop/src/file_picker.dart';
import 'package:file_picker_desktop/src/file_picker_windows.dart';

import 'file_picker_linux.dart';
import 'file_picker_result.dart';
import 'file_type.dart';

/// Opens a dialog to let the user select a directory and returns its absolute path.
///
/// [dialogTitle] is displayed at the top of the file selection dialog. This string
/// can be used to specify instructions to the user.
///
/// Returns a [Future<String>] which resolves to the absolute path of the directory,
/// if the user selected a directory. Returns [null] if folder path couldn't be resolved
/// or the user closed the dialog without making a selection.
Future<String?> getDirectoryPath({
  String dialogTitle = 'Please select a directory:',
}) {
  FilePicker? filePicker;

  if (Platform.isLinux) {
    filePicker = FilePickerLinux();
  } else if (Platform.isWindows) {
    filePicker = FilePickerWindows();
  } else {
    throw UnimplementedError(
      'The current platform "${Platform.operatingSystem}" is not supported by this plugin.',
    );
  }

  return filePicker.getDirectoryPath(dialogTitle: dialogTitle);
}

/// Opens a dialog to let the user select one or multiple files and retrieves the
/// file(s) from the underlying platform.
///
/// [dialogTitle] is displayed at the top of the file selection dialog. This string
/// can be used to specify instructions to the user.
///
/// Default [type] set to [FileType.any] with [allowMultiple] set to [false]
/// Optionally, [allowedExtensions] might be provided (e.g. `['pdf', 'svg', 'jpg']`).
///
/// If [withData] is set, picked files will have its byte data immediately available on memory as `Uint8List`
/// which can be useful if you are picking it for server upload or similar. However, have in mind that
/// enabling this may result in out of memory issues if you pick multiple huge files. Use [withReadStream]
/// instead. Defaults to `false`.
///
/// If [withReadStream] is set, picked files will have its byte data available as a [Stream<List<int>>]
/// which can be useful for uploading and processing large files. Defaults to `false`.
///
/// The result is wrapped in a [FilePickerResult] which contains helper getters
/// with useful information regarding the picked [List<PlatformFile>].
/// Returns [null] if aborted.
Future<FilePickerResult?> pickFiles({
  String dialogTitle = 'Please select file(s):',
  FileType type = FileType.any,
  List<String>? allowedExtensions,
  bool allowMultiple = false,
  bool withData = false,
  bool withReadStream = false,
}) {
  if (type != FileType.custom && (allowedExtensions?.isNotEmpty ?? false)) {
    throw ArgumentError(
        'You are setting a type [$type]. Custom extension filters are only allowed with FileType.custom, please change it or remove filters.');
  } else if (type == FileType.custom && (allowedExtensions?.isEmpty ?? true)) {
    throw ArgumentError(
      'If you are setting the file type to "custom", then a non-empty list of allowed file extensions must be provided.',
    );
  }
  FilePicker? filePicker;

  if (Platform.isLinux) {
    filePicker = FilePickerLinux();
  } else if (Platform.isWindows) {
    filePicker = FilePickerWindows();
  } else {
    throw UnimplementedError(
      'The current platform "${Platform.operatingSystem}" is not supported by this plugin.',
    );
  }

  return filePicker.pickFiles(
    dialogTitle: dialogTitle,
    type: type,
    allowedExtensions: allowedExtensions,
    allowMultiple: allowMultiple,
    withData: withData,
    withReadStream: withReadStream,
  );
}
