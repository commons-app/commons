class Values {
  String value;
  String hidden;
  String source;

  Values({this.value, this.hidden, this.source});

  Values.fromJson(Map<String, dynamic> json) {
    if (json[value] is String) {
      value = json['value'];
    } else {
      value = json['value'].toString();
    }
    hidden = json['hidden'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['hidden'] = this.hidden;
    data['source'] = this.source;
    return data;
  }
}
