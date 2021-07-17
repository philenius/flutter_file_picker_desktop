## 1.0.0

* Fig bug in macOS implementation: the argument string for osascript was wrapped twice in quotes so that osascript didn't interpret the arguments and completed immediately
* Fix file extension filters on macOS 
* Escape title of file picker dialog on macOS to allow double quotes, line breaks, and backslashes
* Manually test implementation on macOS. It works! 🥳

## 1.0.0-dev.1

* Implement picking files and directories for all three platforms: Linux, macOS, and Windows
* The implementation was tested manually on Linux and Windows.
* Couldn't test whether the implementation works on macOS, too.
