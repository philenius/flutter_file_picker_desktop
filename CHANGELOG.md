## 1.1.1

Several bug fixes:
* Fix file type filter `FileType.any` on Linux to allow the selection of files without file extension
* Fix expression for file type filter `FileType.custom` on Windows
* Fix bug on Windows when selecting more than 3 files. Previously, if the user selected multiple (>3 or 4) files, then the file picker dialog would freeze and Flutter would crash.
* Release dynamically allocated memory in Windows implementation after closing the dialog

## 1.1.0

* Add new feature from merge request [#7 add save file dialog support](https://github.com/philenius/flutter_file_picker_desktop/pull/7):Credit for the implementation goes to @f69. Thank you.

## 1.0.2

* Fix issue [#4 Cannot open file in MacOS](https://github.com/philenius/flutter_file_picker_desktop/issues/4):
  picking files or directories on USB sticks / external hard drives caused an exception due to the missing prefix `/Volumes/` in the file path

## 1.0.1

* Fix README: forgot to update version in README after leasing v1.0.0

## 1.0.0

* Fig bug in macOS implementation: the argument string for osascript was wrapped twice in quotes so that osascript didn't interpret the arguments and completed immediately
* Fix file extension filters on macOS 
* Escape title of file picker dialog on macOS to allow double quotes, line breaks, and backslashes
* Manually test implementation on macOS. It works! 🥳

## 1.0.0-dev.1

* Implement picking files and directories for all three platforms: Linux, macOS, and Windows
* The implementation was tested manually on Linux and Windows.
* Couldn't test whether the implementation works on macOS, too.
