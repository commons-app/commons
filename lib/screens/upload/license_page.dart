import 'dart:io';

import 'package:commons/app_config.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:flutter/material.dart';

import 'description_page.dart';

class FileLicensePage extends StatefulWidget {
  final File selectedFile;

  const FileLicensePage({Key key, @required this.selectedFile})
      : super(key: key);

  @override
  _FileLicensePageState createState() =>
      new _FileLicensePageState(selectedFile);
}

class _FileLicensePageState extends State<FileLicensePage> {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  File _image;

  String dropdownValue = UploadHelper.CC_BY_3;

  _FileLicensePageState(File selectedFile) {
    _image = selectedFile;
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var config = AppConfig.of(_ctx);

    var homeAppBar = AppBar(
      title: new Text("Welcome to Commons!"),
    );

    return Scaffold(
      appBar: homeAppBar,
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                  "This site requires you to provide copyright information for this work, to make sure everyone can legally reuse it. I the copyright holder of this work, irrevocably grant anyone the right to use this work under the following license:"),
            ),
            new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  UploadHelper.CC0,
                  UploadHelper.CC_BY_3,
                  UploadHelper.CC_BY_4,
                  UploadHelper.CC_BY_SA_3,
                  UploadHelper.CC_BY_SA_4
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new RaisedButton(
                onPressed: _submit,
                child: new Text("Next"),
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
      key: scaffoldKey,
    );
  }

  void _submit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FileDescriptionPage(file: _image, license: dropdownValue)));
  }
}
