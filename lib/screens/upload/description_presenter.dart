import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:path/path.dart' as p;
import 'package:commons/utils/crypto_utils.dart';

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
        errors.add("Please enter an unique title!");
      }
      return checkForDuplicateFile(uploadableFile);
    }).then((bool exists) {
      if (exists) {
        errors.add("This file already exists on Commons!");
      }
      if (errors.length > 0) {
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

  Future<bool> checkForDuplicateFile(UploadableFile uploadableFile) async {
    String sha1 = await CryptoUtils.getSha1(uploadableFile.file);
    return commonsBloc.checkIfDuplicateFileExists(sha1);
  }
}
