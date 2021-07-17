@TestOn('mac-os')

import 'package:file_picker_desktop/src/file_picker_macos.dart';
import 'package:file_picker_desktop/src/file_type.dart';
import 'package:test/test.dart';

void main() {
  group('fileTypeToFileFilter()', () {
    test('should return the file filter', () {
      final picker = FilePickerMacOS();

      expect(
        picker.fileTypeToFileFilter(FileType.any, null),
        equals(''),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.audio, null),
        equals('"mp3", "wav", "midi", "ogg", "aac"'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.image, null),
        equals('"jpg", "jpeg", "bmp", "gif", "png"'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.media, null),
        equals(
          '"webm", "mpeg", "mkv", "mp4", "avi", "mov", "flv", "jpg", "jpeg", "bmp", "gif", "png"',
        ),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.video, null),
        equals('"webm", "mpeg", "mkv", "mp4", "avi", "mov", "flv"'),
      );
    });

    test(
        'should return the file filter when given a list of custom file extensions',
        () {
      final picker = FilePickerMacOS();

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart']),
        equals('"dart"'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart', 'html']),
        equals('"dart", "html"'),
      );
    });
  });

  group('resultStringToFilePaths()', () {
    test('should interpret the result of picking no files', () {
      final picker = FilePickerMacOS();

      final filePaths = picker.resultStringToFilePaths('  ');
      expect(filePaths.length, equals(0));
      expect(filePaths.length, equals(0));
    });

    test('should interpret the result of picking a single file', () {
      final picker = FilePickerMacOS();

      final filePaths = picker.resultStringToFilePaths(
        'alias macOS:Users:john:Downloads:config.yml',
      );

      expect(filePaths.length, equals(1));
      expect(filePaths[0], equals('/Users/john/Downloads/config.yml'));
    });

    test('should interpret the result of picking two files', () {
      final picker = FilePickerMacOS();

      final filePaths = picker.resultStringToFilePaths(
        'alias macOS:System:usr:lib:lib.dylib, alias macOS:System:usr:lib:libA.dylib',
      );

      expect(filePaths.length, equals(2));
      expect(filePaths[0], equals('/System/usr/lib/lib.dylib'));
      expect(filePaths[1], equals('/System/usr/lib/libA.dylib'));
    });

    test('should interpret the result of picking a directory', () {
      final picker = FilePickerMacOS();

      final filePaths = picker.resultStringToFilePaths(
        'alias macOS:System:iOSSupport:usr:lib:swift',
      );

      expect(filePaths.length, equals(1));
      expect(filePaths[0], equals('/System/iOSSupport/usr/lib/swift'));
    });
  });

  group('generateCommandLineArguments()', () {
    test('should generate the arguments for picking a single file', () {
      final picker = FilePickerMacOS();

      final cliArguments = picker.generateCommandLineArguments(
        'Select a file:',
        multipleFiles: false,
        pickDirectory: false,
      );

      expect(
        cliArguments.join(' '),
        equals('-e choose file of type {} with prompt "Select a file:"'),
      );
    });

    test('should generate the arguments for picking multiple files', () {
      final picker = FilePickerMacOS();

      final cliArguments = picker.generateCommandLineArguments(
        'Select files:',
        multipleFiles: true,
        pickDirectory: false,
      );

      expect(
        cliArguments.join(' '),
        equals(
          '-e choose file of type {} with multiple selections allowed with prompt "Select files:"',
        ),
      );
    });

    test(
        'should generate the arguments for picking a single file with a custom file filter',
        () {
      final picker = FilePickerMacOS();

      final cliArguments = picker.generateCommandLineArguments(
        'Select a file:',
        fileFilter: '"dart", "yml"',
        multipleFiles: false,
        pickDirectory: false,
      );

      expect(
        cliArguments.join(' '),
        equals(
            '-e choose file of type {"dart", "yml"} with prompt "Select a file:"'),
      );
    });

    test(
        'should generate the arguments for picking multiple files with a custom file filter',
        () {
      final picker = FilePickerMacOS();

      final cliArguments = picker.generateCommandLineArguments(
        'Select HTML files:',
        fileFilter: '"html"',
        multipleFiles: true,
        pickDirectory: false,
      );

      expect(
        cliArguments.join(' '),
        equals(
          '-e choose file of type {"html"} with multiple selections allowed with prompt "Select HTML files:"',
        ),
      );
    });

    test('should generate the arguments for picking a directory', () {
      final picker = FilePickerMacOS();

      final cliArguments = picker.generateCommandLineArguments(
        'Select a directory:',
        pickDirectory: true,
      );

      expect(
        cliArguments.join(' '),
        equals('-e choose folder with prompt "Select a directory:"'),
      );
    });
  });
}
