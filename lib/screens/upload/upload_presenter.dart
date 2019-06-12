import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';

abstract class UploadPageContract {
  void onImageUploadSuccess(String success);

  void onImageUploadError(String error);
}

class UploadPagePresenter {
  UploadPageContract _view;
  CommonsBloc commonsBloc;
  UploadHelper _uploadHelper;

  UploadPagePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
    _uploadHelper = new UploadHelper();
  }

  uploadFile(
      File file, String filename, String description, String license) async {
    var text = await _uploadHelper.getPageText(
        description, DateTime.now(), 12.9593548, 77.643414, license, ["Test"]);

    print(text);

    commonsBloc
        .uploadFile(file, filename, text)
        .then((uploadResponse) => _view.onImageUploadSuccess("Image uploaded!"))
        .catchError((onError) => _view.onImageUploadError(onError.toString()));
  }
}
