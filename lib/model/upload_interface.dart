import 'package:commons/model/response/upload/UploadResult.dart';

abstract class UploadInterface {
  void onUploadProgessChanged(int sent, int total);
  void onUploadSuccessful(UploadResult uploadResult);
  void onUploadFailure(String error);
}