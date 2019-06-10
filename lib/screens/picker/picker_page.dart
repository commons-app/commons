import 'dart:io';

import 'package:flutter/material.dart';

import 'picker_presenter.dart';

class PickerPage extends StatefulWidget {
  @override
  _PickerPageState createState() => new _PickerPageState();
}

class _PickerPageState extends State<PickerPage> implements PickerPageContract {
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  PickerPagePresenter _presenter;

  _PickerPageState() {
    _presenter = new PickerPagePresenter(this);
  }

  void _pickImage() async {
    var image = await _presenter.getImage();

    _presenter.uploadFile(image, "Test.jpg");

    setState(() {
      _image = image;
    });
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose image'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
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
