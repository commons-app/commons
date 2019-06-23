import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:path/path.dart' as p;

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
    checkIfFileExists(uploadableFile).then((bool fileExists) {
      if (fileExists) {
        errors.add("Duplicate file name!");
        _view.onQualityChecksFailed(errors);
      } else {
        _view.onQualityChecksPassed();
      }
    });
  }

  Future<bool> checkIfFileExists(UploadableFile uploadableFile) {
    String fileExtension = p.extension(uploadableFile.file.path);
    return commonsBloc.checkIfPageExists(
        "File:" + uploadableFile.title + "." + fileExtension);
  }
}
