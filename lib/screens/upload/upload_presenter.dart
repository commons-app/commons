import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/upload/UploadResult.dart';
import 'package:commons/model/upload_interface.dart';

abstract class UploadPageContract {
  void onImageProgressChanged(double percentage);

  void onImageUploadSuccess(String success);

  void onImageUploadError(String error);
}

class UploadPagePresenter implements UploadInterface {
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

    commonsBloc.uploadFile(
        uploadableFile.file, uploadableFile.title, text, this);
  }

  editWikiDataItem(String filename, Place place) {

  }

  Future<List<Category>> filterSearchResults(UploadableFile uploadableFile,
      String query) {
    if (query == "") {
      return getCategorySuggestion(uploadableFile);
    } else if (query != "") {
      return commonsBloc.getCategories(query);
    }
    return Future.value(List());
  }

  Future<List<Category>> getCategorySuggestion(UploadableFile uploadableFile) {
    var futures = [];
    Future<List<Category>> gpsBasedSuggestions;
    if (uploadableFile.latLng != null) {
      gpsBasedSuggestions = commonsBloc
          .getNearbyCategories(
          uploadableFile.latLng);
      futures.add(gpsBasedSuggestions);
    } else {
      gpsBasedSuggestions = Future.value(List());
    }
    Future<List<Category>> titleBasedSuggestions;
    if (uploadableFile.title != null) {
      titleBasedSuggestions = commonsBloc
          .getCategories(uploadableFile.title);
      futures.add(titleBasedSuggestions);
    } else {
      titleBasedSuggestions = Future.value(List());
    }

    return Future.wait([titleBasedSuggestions, gpsBasedSuggestions])
        .then((List<List<Category>> results) {
      List<Category> categorySuggestions = List();
      results.forEach((List<Category> categories) {
        categories.forEach((Category category) {
          categorySuggestions.add(category);
        });
      });
      return categorySuggestions;
    }, onError: (e) {
      throw e;
    });
  }

  @override
  void onUploadFailure(String error) {
    _view.onImageUploadError(error);
  }

  @override
  void onUploadProgessChanged(int sent, int total) {
    _view.onImageProgressChanged(((sent / total) * 100.0));
  }

  @override
  void onUploadSuccessful(UploadResult uploadResult) {
    if (uploadResult.upload != null &&
        uploadResult.upload.result.toLowerCase() ==
            "Success".toLowerCase()) {
      _view.onImageUploadSuccess("Image uploaded!");
    } else {
      _view.onImageUploadError("Error occurred");
    }
  }
}
