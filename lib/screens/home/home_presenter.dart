import 'dart:async';
import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:image_picker/image_picker.dart';

abstract class PickerPageContract {
  void onImageUploadSuccess(String success);

  void onImageUploadError(String error);
}

class PickerPagePresenter {
  PickerPageContract _view;
  CommonsBloc commonsBloc = new CommonsBloc();

  PickerPagePresenter(this._view);

  Future<File> getImage() async {
    return ImagePicker.pickImage(source: ImageSource.camera);
  }

  uploadFile(File file, String filename) {
    commonsBloc
        .uploadFile(file, filename)
        .then((uploadResponse) => _view.onImageUploadSuccess("Image uploaded!"))
        .catchError((onError) => _view.onImageUploadError(onError.toString()));
  }
}
