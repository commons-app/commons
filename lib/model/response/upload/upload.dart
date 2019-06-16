import 'package:commons/model/response/media/ImageInfo.dart';

class Upload {
  String filename;
  String result;
  Imageinfo imageinfo;

  Upload({this.filename, this.result, this.imageinfo});

  Upload.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    result = json['result'];
    imageinfo = json['imageinfo'] != null
        ? new Imageinfo.fromJson(json['imageinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['result'] = this.result;
    if (this.imageinfo != null) {
      data['imageinfo'] = this.imageinfo.toJson();
    }
    return data;
  }
}
