import 'dart:io';

import 'package:commons/screens/login/login_page.dart';
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
  var appBarTitleText = new Text("Welcome!");

  _HomePageState() {
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
  void initState() {
    super.initState();
    checkIsLogin();
  }

  Future<Null> checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn != null && isLoggedIn) {
      print("User is logged in");
      var username = prefs.getString("username");
      appBarTitleText = new Text(username);
    }
    else {
      print("User is not logged in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var homeAppBar = AppBar(
      title: appBarTitleText,
    );
    return Scaffold(
      appBar: homeAppBar,
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
