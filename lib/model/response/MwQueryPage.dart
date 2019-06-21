import 'media/ImageInfo.dart';

class MwQueryPage {
  int pageid;
  int ns;
  String title;
  String imagerepository;
  List<ImageInfo> imageinfo;

  MwQueryPage(
      {this.pageid, this.ns, this.title, this.imagerepository, this.imageinfo});

  MwQueryPage.fromJson(Map<String, dynamic> json) {
    pageid = json['pageid'];
    ns = json['ns'];
    title = json['title'];
    imagerepository = json['imagerepository'];
    if (json['imageinfo'] != null) {
      imageinfo = new List<ImageInfo>();
      json['imageinfo'].forEach((v) {
        imageinfo.add(new ImageInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageid'] = this.pageid;
    data['ns'] = this.ns;
    data['title'] = this.title;
    data['imagerepository'] = this.imagerepository;
    if (this.imageinfo != null) {
      data['imageinfo'] = this.imageinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
