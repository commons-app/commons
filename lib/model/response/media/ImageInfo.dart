import 'ExtMetaData.dart';
import 'MetaData.dart';

class ImageInfo {
  String url;
  String html;
  int width;
  int size;
  int bitdepth;
  String mime;
  int userid;
  String mediatype;
  String descriptionurl;
  Extmetadata extmetadata;
  String comment;
  String descriptionshorturl;
  String sha1;
  String parsedcomment;
  List<Metadata> metadata;
  String canonicaltitle;
  String user;
  String timestamp;
  int height;

  ImageInfo(
      {this.url,
      this.html,
      this.width,
      this.size,
      this.bitdepth,
      this.mime,
      this.userid,
      this.mediatype,
      this.descriptionurl,
      this.extmetadata,
      this.comment,
      this.descriptionshorturl,
      this.sha1,
      this.parsedcomment,
      this.metadata,
      this.canonicaltitle,
      this.user,
      this.timestamp,
      this.height});

  ImageInfo.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    html = json['html'];
    width = json['width'];
    size = json['size'];
    bitdepth = json['bitdepth'];
    mime = json['mime'];
    userid = json['userid'];
    mediatype = json['mediatype'];
    descriptionurl = json['descriptionurl'];
    extmetadata = json['extmetadata'] != null
        ? new Extmetadata.fromJson(json['extmetadata'])
        : null;
    comment = json['comment'];
    descriptionshorturl = json['descriptionshorturl'];
    sha1 = json['sha1'];
    parsedcomment = json['parsedcomment'];
    if (json['metadata'] != null) {
      metadata = new List<Metadata>();
      json['metadata'].forEach((v) {
        metadata.add(new Metadata.fromJson(v));
      });
    }
    canonicaltitle = json['canonicaltitle'];
    user = json['user'];
    timestamp = json['timestamp'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['html'] = this.html;
    data['width'] = this.width;
    data['size'] = this.size;
    data['bitdepth'] = this.bitdepth;
    data['mime'] = this.mime;
    data['userid'] = this.userid;
    data['mediatype'] = this.mediatype;
    data['descriptionurl'] = this.descriptionurl;
    if (this.extmetadata != null) {
      data['extmetadata'] = this.extmetadata.toJson();
    }
    data['comment'] = this.comment;
    data['descriptionshorturl'] = this.descriptionshorturl;
    data['sha1'] = this.sha1;
    data['parsedcomment'] = this.parsedcomment;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.map((v) => v.toJson()).toList();
    }
    data['canonicaltitle'] = this.canonicaltitle;
    data['user'] = this.user;
    data['timestamp'] = this.timestamp;
    data['height'] = this.height;
    return data;
  }
}
