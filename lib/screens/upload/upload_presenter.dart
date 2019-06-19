import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/upload/UploadResult.dart';

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

  uploadFile(UploadableFile uploadableFile) async {
    var text = await _uploadHelper.getPageText(uploadableFile);

    print(text);

    commonsBloc
        .uploadFile(uploadableFile.file, uploadableFile.title, text)
        .then((UploadResult uploadResponse) {
      if (uploadResponse.upload != null &&
          uploadResponse.upload.result.toLowerCase() ==
          "Success".toLowerCase()) {
        _view.onImageUploadSuccess("Image uploaded!");
      } else {
        _view.onImageUploadError("Error occurred");
      }
    })
        .catchError((onError) => _view.onImageUploadError(onError.toString()));
  }

  editWikiDataItem(String filename, Place place) {

  }

  Future<List<Category>> filterSearchResults(String query) {
    if (query == "") {
      return Future.value(List());
    }
    return commonsBloc.getCategories(query);
  }
}
