import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/category.dart';

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

  uploadFile(File file, String filename, String description, String license,
      List<Category> selectedCategoryItems) async {
    var categories = selectedCategoryItems.map((val) => val.categoryName)
        .toList();
    var text = await _uploadHelper.getPageText(
        description, DateTime.now(), 12.9593548, 77.643414, license,
        categories);

    commonsBloc
        .uploadFile(file, filename, text)
        .then((uploadResponse) => _view.onImageUploadSuccess("Image uploaded!"))
        .catchError((onError) => _view.onImageUploadError(onError.toString()));
  }

  Future<List<Category>> filterSearchResults(String query) {
    if (query == "") {
      return Future.value(List());
    }
    return commonsBloc.getCategories(query);
  }
}
