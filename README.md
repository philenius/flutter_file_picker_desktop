# File Picker Desktop

[![CI Pipeline](https://github.com/philenius/flutter_file_picker_desktop/actions/workflows/main.yml/badge.svg)](https://github.com/philenius/flutter_file_picker_desktop/actions/workflows/main.yml)

This repository contains a Dart package that allows you to use a native file explorer on Windows, macOS, and Linux. The package offers a simple API:

* Pick a single file or multiple files with support for filtering the allowed file extensions
* Pick a directory


| Linux                                                        |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |
| **Windows**                                                  |                                                              |
| ![Windows File Picker](screenshots/screenshotWindowsPickFiles.png) | ![Windows File Picker](screenshots/screenshotWindowsPickDirectory.png) |
| **macOS**                                                    |                                                              |


## Example Flutter App

![Demo Flutter App](screenshots/screenshotDemoApp.png)

The directory `./example/` contains an example Flutter app which showcases the file picker's functionality. You can run this example app the following way:

```bash
cd ./example/

flutter create .

# Choose the appropriate option depending on your OS
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop

flutter run
```