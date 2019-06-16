import 'dart:io';

import 'package:commons/helper/upload_helper.dart';
import 'package:commons/screens/upload/upload_category_page.dart';
import 'package:flutter/material.dart';

class FileDescriptionPage extends StatefulWidget {
  final File file;

  const FileDescriptionPage({Key key, @required this.file})
      : super(key: key);

  @override
  _FileDescriptionPageState createState() =>
      new _FileDescriptionPageState(file);
}

class _FileDescriptionPageState extends State<FileDescriptionPage> {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  File _image;

  var _title;
  var _caption;
  var _description;
  String _license = UploadHelper.CC_BY_3;

  _FileDescriptionPageState(File file) {
    _image = file;
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

    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(25.0)));

    var homeAppBar = AppBar(
      title: const Text('Upload Image'),
      actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            _submit();
          },
        ),
      ],
    );

    var uploadForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _title = val,
                    decoration: new InputDecoration(labelText: "Title",
                        border: outlineInputBorder),
                  )),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _caption = val,
                    decoration: new InputDecoration(labelText: "Caption",
                        border: outlineInputBorder),
                  )),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _description = val,
                    decoration: new InputDecoration(labelText: "Description",
                        border: outlineInputBorder),
                  )),
              new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Text(
                    "This site requires you to provide copyright information for this work, to make sure everyone can legally reuse it. I the copyright holder of this work, irrevocably grant anyone the right to use this work under the following license:"),
              ),
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new DropdownButton<String>(
                  value: _license,
                  onChanged: (String newValue) {
                    setState(() {
                      _license = newValue;
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
              )
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: homeAppBar,
      body: new Container(child: uploadForm),
      key: scaffoldKey,
    );
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FileCategoryPage(file: _image,
                        title: _title,
                        caption: _caption,
                        description: _description,
                        license: _license)));
      });
    }
  }
}
