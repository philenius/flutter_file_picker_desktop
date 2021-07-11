import 'dart:io';

setUpTestFiles(
  String imageTestFile,
  String pdfTestFile,
  String yamlTestFile,
) {
  new File(
    './test/test_files/franz-michael-schneeberger-unsplash.jpg',
  ).copySync(imageTestFile);
  new File(
    './test/test_files/test.pdf',
  ).copySync(pdfTestFile);
  new File(
    './test/test_files/test.yml',
  ).copySync(yamlTestFile);
}

tearDownTestFiles(
  String imageTestFile,
  String pdfTestFile,
  String yamlTestFile,
) {
  new File(imageTestFile).deleteSync();
  new File(pdfTestFile).deleteSync();
  new File(yamlTestFile).deleteSync();
}
