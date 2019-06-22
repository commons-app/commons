import 'dart:async';
import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class HomePageContract {
}

class HomePagePresenter {
  HomePageContract _view;
  CommonsBloc commonsBloc;
  UploadHelper _uploadHelper;


  HomePagePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
    _uploadHelper = new UploadHelper();
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
}
