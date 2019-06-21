import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/UploadableFile.dart';

abstract class FileDescriptionPageContract {
  void onQualityChecksPassed();

  void onQualityChecksFailed(List<String> errorMessages);
}

class FileDescriptionPagePresenter {
  FileDescriptionPageContract _view;
  CommonsBloc commonsBloc;

  FileDescriptionPagePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  void performFileQualityChecks(UploadableFile uploadableFile) {
    var errors = List();
    checkIfFileExists(uploadableFile.title).then((bool fileExists) {
      if (fileExists) {
        errors.add("Duplicate file name!");
        _view.onQualityChecksFailed(errors);
      } else {
        _view.onQualityChecksPassed();
      }
    });
  }

  Future<bool> checkIfFileExists(String title) {
    return commonsBloc.checkIfPageExists("File:" + title);
  }
}
