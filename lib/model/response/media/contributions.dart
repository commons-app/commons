import 'ExtMetaData.dart';

class AllImages {
  String name;
  String url;
  String descriptionurl;
  String descriptionshorturl;
  Extmetadata extmetadata;
  int ns;
  String title;

  AllImages(
      {this.name,
      this.url,
      this.descriptionurl,
      this.descriptionshorturl,
      this.extmetadata,
      this.ns,
      this.title});

  AllImages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    descriptionurl = json['descriptionurl'];
    descriptionshorturl = json['descriptionshorturl'];
    extmetadata = json['extmetadata'] != null
        ? new Extmetadata.fromJson(json['extmetadata'])
        : null;
    ns = json['ns'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['descriptionurl'] = this.descriptionurl;
    data['descriptionshorturl'] = this.descriptionshorturl;
    if (this.extmetadata != null) {
      data['extmetadata'] = this.extmetadata.toJson();
    }
    data['ns'] = this.ns;
    data['title'] = this.title;
    return data;
  }
}
