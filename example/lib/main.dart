import 'package:file_picker_desktop/file_picker_desktop.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Native File Picker for Desktop',
      theme: ThemeData(
        primaryColor: Colors.grey.shade800,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _selection = [];
  bool _multipleFiles = false;
  FileType _fileType = FileType.any;
  bool _isAllowedFileTypesInputVisible = false;
  TextEditingController _allowedFileTypesController = TextEditingController();

  Future<void> _pickDirectory() async {
    try {
      final String? selectedDirectory = await getDirectoryPath(
        dialogTitle: 'Please select a directory:',
      );
      if (selectedDirectory != null) {
        setState(() {
          this._selection = [selectedDirectory];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('User closed the dialog without selecting a directory.'),
          ),
        );
        setState(() {
          this._selection = [];
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Exception: $e'),
        ),
      );
      setState(() {
        this._selection = [];
      });
    }
  }

  Future<void> _pickFile() async {
    final allowedFileTypes = this
        ._allowedFileTypesController
        .text
        .split(',')
        .map((fileType) => fileType.trim())
        .toList();

    try {
      final FilePickerResult? result = await pickFiles(
        allowMultiple: this._multipleFiles,
        allowedExtensions:
            this._fileType == FileType.custom ? allowedFileTypes : null,
        type: this._fileType,
      );

      if (result != null) {
        setState(() {
          this._selection = result.files.map((e) => e.path ?? 'ERROR').toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User closed the dialog without selecting a file.'),
          ),
        );
        setState(() {
          this._selection = [];
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Exception: $e'),
        ),
      );
      setState(() {
        this._selection = [];
      });
    }
  }

  Future<void> _saveFile() async {
    final allowedFileTypes = this
        ._allowedFileTypesController
        .text
        .split(',')
        .map((fileType) => fileType.trim())
        .toList();

    try {
      final String? result = await saveFile(
        allowedExtensions:
            this._fileType == FileType.custom ? allowedFileTypes : null,
        dialogTitle: 'Please select the output file:',
        defaultFileName: 'default-file.txt',
        type: this._fileType,
      );

      if (result != null) {
        setState(() {
          this._selection = [result];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User closed the dialog without selecting a file.'),
          ),
        );
        setState(() {
          this._selection = [];
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Exception: $e'),
        ),
      );
      setState(() {
        this._selection = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Native File Picker for Desktop'),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          children: [
            Row(
              children: [
                Text('Select multiple files:'),
                SizedBox(
                  width: 10,
                ),
                Switch(
                  value: _multipleFiles,
                  onChanged: (newValue) {
                    setState(() {
                      this._multipleFiles = newValue;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('Filter for file types:'),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<FileType>(
                  value: _fileType,
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (FileType? newValue) {
                    setState(() {
                      _fileType = newValue!;
                      this._isAllowedFileTypesInputVisible =
                          this._fileType == FileType.custom;
                    });
                  },
                  items: FileType.values
                      .map(
                        (fileType) => DropdownMenuItem<FileType>(
                          child: Text(fileType.toString()),
                          value: fileType,
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  width: 32,
                ),
                _isAllowedFileTypesInputVisible
                    ? Expanded(
                        child: TextField(
                          controller: this._allowedFileTypesController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Allowed file types:',
                            helperText:
                                'Enter a comma-separated list of allowed file extensions (without asterisks and without dots)',
                            hintText: 'png, jpeg, bmp',
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: this._pickDirectory,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Pick a directory',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: this._pickFile,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _multipleFiles ? 'Pick files' : 'Pick a file',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: this._saveFile,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Save a file'),
                  ),
                ),
              ],
            ),
            Divider(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  'Selection:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            IntrinsicWidth(
              child: Container(
                height: 400,
                child: this._selection.isEmpty
                    ? Text('Nothing selected')
                    : ListView.builder(
                        itemCount: this._selection.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                          title: Text(this._selection[index]),
                          leading: Icon(Icons.folder),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
