class Metadata {
  String name;
  String value;

  Metadata({this.name, this.value});

  Metadata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if(json["value"] is String) {
      value = json['value'];
    } else {
      value = json['value'].toString();
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
