
import 'package:file_picker_desktop/file_picker_desktop.dart';
import 'package:test/test.dart';

void main() {
  group('pickFiles()', () {
    test(
        'should throw an exception if file type is set to "custom" and no list of allowed file extensions was given',
        () {
      expect(
        () => pickFiles(
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
        () => pickFiles(
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
      expect(
        () => pickFiles(
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
}