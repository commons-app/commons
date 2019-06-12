import 'dart:async';
import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:commons/helper/upload_helper.dart';

abstract class PickerPageContract {
  void onImageUploadSuccess(String success);

  void onImageUploadError(String error);
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

  uploadFile(File file, String filename) async {
    var text = await _uploadHelper.getPageText(
        "", DateTime.now(), 12.9593548, 77.643414, UploadHelper.CC_BY_SA_4,
        ["Test"]);

    print(text);

    commonsBloc
        .uploadFile(file, filename, text)
        .then((uploadResponse) => _view.onImageUploadSuccess("Image uploaded!"))
        .catchError((onError) => _view.onImageUploadError(onError.toString()));
  }
}
