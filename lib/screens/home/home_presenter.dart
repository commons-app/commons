import 'dart:async';
import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:commons/helper/upload_helper.dart';

abstract class PickerPageContract {
}

class PickerPagePresenter {
  PickerPageContract _view;
  CommonsBloc commonsBloc;
  UploadHelper _uploadHelper;


  PickerPagePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
    _uploadHelper = new UploadHelper();
  }

  Future<File> getImageFromCamera() async {
    return ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> getImageFromGallery() async {
    return ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
