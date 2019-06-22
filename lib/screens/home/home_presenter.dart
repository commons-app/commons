import 'dart:async';
import 'dart:io';

import 'package:commons/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class HomePageContract {
  void redirectUserForLogin();
}

class HomePagePresenter {
  HomePageContract _view;


  HomePagePresenter(this._view);

  void checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
      _view.redirectUserForLogin();
    }
  }

  void redirectToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => new LoginPage()),
    );
  }

  Future<File> getImageFromCamera() async {
    return ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> getImageFromGallery() async {
    return ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void appReview() {
    LaunchReview.launch();
  }

  void sendFeedback() async {
    var emailLauncher = "mailto:commons-app-android@googlegroups.com?subject=Commons App Feedback";
    launch(emailLauncher);
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _view.redirectUserForLogin();
  }
}
