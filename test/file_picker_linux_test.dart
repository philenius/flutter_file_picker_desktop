@TestOn('linux')

import 'package:file_picker_desktop/src/file_picker_linux.dart';
import 'package:file_picker_desktop/src/file_type.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  final imageTestFile = '/tmp/test_linux.jpg';
  final pdfTestFile = '/tmp/test_linux.pdf';
  final yamlTestFile = '/tmp/test_linux.yml';

  setUpAll(
    () => setUpTestFiles(imageTestFile, pdfTestFile, yamlTestFile),
  );

  tearDownAll(
    () => tearDownTestFiles(imageTestFile, pdfTestFile, yamlTestFile),
  );

  group('pickFiles()', () {
    test(
        'should throw an exception if file type is set to "custom" and no list of allowed file extensions was given',
        () {
      final picker = FilePickerLinux();

      expect(
        () => picker.pickFiles(
          allowedExtensions: null,
          allowMultiple: false,
          dialogTitle: '',
          type: FileType.custom,
          withData: false,
          withReadStream: false,
        ),
        throwsArgumentError,
      );

      expect(
        () => picker.pickFiles(
          allowedExtensions: [],
          allowMultiple: false,
          dialogTitle: '',
          type: FileType.custom,
          withData: false,
          withReadStream: false,
        ),
        throwsArgumentError,
      );
    });

    test(
        'should throw an exception if the file type is not "custom" but a list of allowed file extensions was given',
        () {
      final picker = FilePickerLinux();

      expect(
        () => picker.pickFiles(
          allowedExtensions: ['png'],
          allowMultiple: false,
          dialogTitle: '',
          type: FileType.audio,
          withData: false,
          withReadStream: false,
        ),
        throwsArgumentError,
      );
    });
  });

  group('fileTypeToFileFilter()', () {
    test('should return the file filter', () {
      final picker = FilePickerLinux();

      expect(
        picker.fileTypeToFileFilter(FileType.any, null),
        equals('*.*'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.audio, null),
        equals('*.mp3 *.wav *.midi *.ogg *.aac'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.image, null),
        equals('*.png *.jpg *.jpeg'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.media, null),
        equals(
            '*.png *.jpg *.jpeg *.webm *.mpeg *.mkv *.mp4 *.avi *.mov *.flv'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.video, null),
        equals('*.webm *.mpeg *.mkv *.mp4 *.avi *.mov *.flv'),
      );
    });

    test(
        'should return the file filter when given a list of custom file extensions',
        () {
      final picker = FilePickerLinux();

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart']),
        equals('*.dart'),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart', 'html']),
        equals('*.dart *.html'),
      );
    });
  });

  group('resultStringToPlatformFiles()', () {
    test('should interpret the result of picking a single file', () async {
      final picker = FilePickerLinux();
      final fileSelectionResult = imageTestFile;

      final platformFiles = await picker.resultStringToPlatformFiles(
          fileSelectionResult, false, false);

      expect(platformFiles.length, equals(1));
      expect(platformFiles[0].extension, equals('jpg'));
      expect(platformFiles[0].name, equals('test_linux.jpg'));
      expect(platformFiles[0].path, equals(imageTestFile));
      expect(platformFiles[0].size, equals(4073378));
    });

    test('should return an empty list if the file picker result was empty',
        () async {
      final picker = FilePickerLinux();
      final fileSelectionResult = '';

      final platformFiles = await picker.resultStringToPlatformFiles(
          fileSelectionResult, false, false);

      expect(platformFiles.length, equals(0));
    });

    test('should interpret the result of picking multiple files', () async {
      final picker = FilePickerLinux();
      final fileSelectionResult =
          '${imageTestFile}|${pdfTestFile}|${yamlTestFile}';

      final platformFiles = await picker.resultStringToPlatformFiles(
          fileSelectionResult, false, false);

      expect(platformFiles.length, equals(3));

      expect(platformFiles[0].extension, equals('jpg'));
      expect(platformFiles[0].name, equals('test_linux.jpg'));
      expect(platformFiles[0].path, equals(imageTestFile));
      expect(platformFiles[0].size, equals(4073378));

      expect(platformFiles[1].extension, equals('pdf'));
      expect(platformFiles[1].name, equals('test_linux.pdf'));
      expect(platformFiles[1].path, equals(pdfTestFile));
      expect(platformFiles[1].size, equals(7478));

      expect(platformFiles[2].extension, equals('yml'));
      expect(platformFiles[2].name, equals('test_linux.yml'));
      expect(platformFiles[2].path, equals(yamlTestFile));
      expect(platformFiles[2].size, equals(213));
    });

    test(
        'should correctly interpret the result even if it ends with an additional pipe',
        () async {
      final picker = FilePickerLinux();
      final fileSelectionResult = '${yamlTestFile}|${pdfTestFile}|';

      final platformFiles = await picker.resultStringToPlatformFiles(
          fileSelectionResult, false, false);

      expect(platformFiles.length, equals(2));

      expect(platformFiles[0].extension, equals('yml'));
      expect(platformFiles[0].name, equals('test_linux.yml'));
      expect(platformFiles[0].path, equals(yamlTestFile));
      expect(platformFiles[0].size, equals(213));

      expect(platformFiles[1].extension, equals('pdf'));
      expect(platformFiles[1].name, equals('test_linux.pdf'));
      expect(platformFiles[1].path, equals(pdfTestFile));
      expect(platformFiles[1].size, equals(7478));
    });
  });
}
