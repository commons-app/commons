class Values {
  String value;
  String hidden;
  String source;

  Values({this.value, this.hidden, this.source});

  Values.fromJson(Map<String, dynamic> json) {
    value = json['value'];
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
