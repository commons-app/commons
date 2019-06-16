import 'Values.dart';

class Extmetadata {
  Values objectName;
  Values dateTime;

  Extmetadata({this.objectName, this.dateTime});

  Extmetadata.fromJson(Map<String, dynamic> json) {
    objectName = json['ObjectName'] != null
        ? new Values.fromJson(json['ObjectName'])
        : null;
    dateTime = json['DateTime'] != null
        ? new Values.fromJson(json['DateTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.objectName != null) {
      data['ObjectName'] = this.objectName.toJson();
    }
    if (this.dateTime != null) {
      data['DateTime'] = this.dateTime.toJson();
    }
    return data;
  }
}
