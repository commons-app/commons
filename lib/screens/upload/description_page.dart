import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:commons/app_config.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/screens/upload/upload_presenter.dart';
import 'package:flutter/material.dart';

class FileDescriptionPage extends StatefulWidget {
  final File file;
  final String license;

  const FileDescriptionPage(
      {Key key, @required this.file, @required this.license})
      : super(key: key);

  @override
  _FileDescriptionPageState createState() =>
      new _FileDescriptionPageState(file, license);
}

class _FileDescriptionPageState extends State<FileDescriptionPage>
    implements UploadPageContract {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  File _image;
  String _license;

  var _title;
  var _caption;
  var _description;

  UploadPagePresenter _presenter;

  String dropdownValue = UploadHelper.CC_BY_3;

  _FileDescriptionPageState(File file, String license) {
    _image = file;
    _license = license;
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
    _presenter = new UploadPagePresenter(config.commonsBaseUrl, this);

    var homeAppBar = AppBar(
      title: new Text("Welcome to Commons!"),
    );

    var categoriesSearch = new AutoCompleteTextField<String>(
      style: new TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: new InputDecoration(
          suffixIcon: Container(
            width: 85.0,
            height: 60.0,
          ),
          contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
          filled: true,
          hintText: 'Search Player Name',
          hintStyle: TextStyle(color: Colors.black)),
      itemBuilder: (context, item) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item,
              style: TextStyle(fontSize: 16.0),
            )
          ],
        );
      },
    );

    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Upload"),
      color: Colors.green,
    );

    var uploadForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new TextFormField(
                    onSaved: (val) => _title = val,
                    decoration: new InputDecoration(labelText: "Title"),
                  )),
              new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new TextFormField(
                    onSaved: (val) => _caption = val,
                    decoration: new InputDecoration(labelText: "Caption"),
                  )),
              new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new TextFormField(
                    onSaved: (val) => _description = val,
                    decoration: new InputDecoration(labelText: "Description"),
                  )),
              new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Text("Categories"),
              ),
            ],
          ),
        ),
        loginBtn
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
        _presenter.uploadFile(_image, _title, _description, _license);
      });
    }
  }

  @override
  void onImageUploadError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onImageUploadSuccess(String success) {
    _showSnackBar(success);
    setState(() {
      _isLoading = false;
    });
  }
}
