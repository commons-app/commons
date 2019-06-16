import 'Upload.dart';

class UploadResult {
  Upload upload;

  UploadResult({this.upload});

  UploadResult.fromJson(Map<String, dynamic> json) {
    upload =
        json['upload'] != null ? new Upload.fromJson(json['upload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upload != null) {
      data['upload'] = this.upload.toJson();
    }
    return data;
  }
}
