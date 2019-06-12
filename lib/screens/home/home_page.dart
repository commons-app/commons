import 'dart:io';

import 'package:commons/app_config.dart';
import 'package:commons/screens/login/login_page.dart';
import 'package:commons/widgets/fancy_fab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements PickerPageContract {
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  PickerPagePresenter _presenter;

  void _pickImageFromCamera() async {
    var image = await _presenter.getImageFromCamera();

    uploadImage(image);

    setState(() {
      _image = image;
    });
  }

  void _pickImageFromGallery() async {
    var image = await _presenter.getImageFromGallery();

    uploadImage(image);

    setState(() {
      _image = image;
    });
  }

  void uploadImage(File image) {
    _presenter.uploadFile(image, "Test.jpg");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  Future<Null> checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
      print("User is not logged in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new LoginPage()),
      );
    }
  }

  Widget gallery() {
    return Container(
      child: FloatingActionButton(
        onPressed: _pickImageFromGallery,
        tooltip: 'Gallery',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget camera() {
    return Container(
      child: FloatingActionButton(
        onPressed: _pickImageFromCamera,
        tooltip: 'Camera',
        child: Icon(Icons.photo_camera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var config = AppConfig.of(_ctx);
    _presenter = new PickerPagePresenter(config.commonsBaseUrl, this);

    var homeAppBar = AppBar(
      title: new Text("Welcome to Commons!"),
    );

    return Scaffold(
      appBar: homeAppBar,
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      key: scaffoldKey,
      floatingActionButton: FancyFab(
        onCameraPressed: _pickImageFromCamera,
        onGalleryPressed: _pickImageFromGallery,
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
