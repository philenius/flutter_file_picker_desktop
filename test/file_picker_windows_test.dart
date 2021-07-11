@TestOn('windows')

import 'dart:io';

import 'package:file_picker_desktop/file_picker_desktop.dart';
import 'package:file_picker_desktop/src/file_picker_windows.dart';
import 'package:test/test.dart';

void main() {
  final imageTestFile = 'C:\\temp\\test_linux.jpg';
  final pdfTestFile = 'C:\\temp\\test_linux.pdf';
  final yamlTestFile = 'C:\\temp\\test_linux.yml';

  setUpAll(() {
    Directory('C:\\temp').createSync();

    File(
      '.\\test\\test_files\\franz-michael-schneeberger-unsplash.jpg',
    ).copySync(imageTestFile);
    File(
      '.\\test\\test_files\\test.pdf',
    ).copySync(pdfTestFile);
    File(
      '.\\test\\test_files\\test.yml',
    ).copySync(yamlTestFile);
  });

  tearDownAll(() {
    Directory('C:\\temp').deleteSync(recursive: true);
  });

  group('fileTypeToFileFilter()', () {
    test('should return the file filter', () {
      final picker = FilePickerWindows();

      expect(
        picker.fileTypeToFileFilter(FileType.any, null),
        equals('*.*\x00\x00'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.audio, null),
        equals('Audios (*.mp3)\x00*.mp3\x00All Files (*.*)\x00*.*\x00\x00'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.image, null),
        equals(
          'Images (*.jpeg,*.png,*.gif)\x00*.jpg;*.jpeg;*.png;*.gif\x00All Files (*.*)\x00*.*\x00\x00',
        ),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.media, null),
        equals(
          'Videos (*.webm,*.wmv,*.mpeg,*.mkv,*.mp4,*.avi,*.mov,*.flv)\x00*.webm;*.wmv;*.mpeg;*.mkv;*mp4;*.avi;*.mov;*.flv\x00Images (*.jpeg,*.png,*.gif)\x00*.jpg;*.jpeg;*.png;*.gif\x00All Files (*.*)\x00*.*\x00\x00',
        ),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.video, null),
        equals(
          'Videos (*.webm,*.wmv,*.mpeg,*.mkv,*.mp4,*.avi,*.mov,*.flv)\x00*.webm;*.wmv;*.mpeg;*.mkv;*mp4;*.avi;*.mov;*.flv\x00All Files (*.*)\x00*.*\x00\x00',
        ),
      );
    });

    test(
        'should return the file filter when given a list of custom file extensions',
        () {
      final picker = FilePickerWindows();

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart']),
        equals('Files (*.dart)\x00\x00'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart', 'html']),
        equals('Files (*.dart,*.html)\x00\x00'),
      );
    });
  });
}
