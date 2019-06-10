import 'package:json_annotation/json_annotation.dart';

part 'RequestField.g.dart';

@JsonSerializable()
class RequestField {
  String type;
  String label;
  String help;

  RequestField(this.type, this.label, this.help);

  factory RequestField.fromJson(Map<String, dynamic> json) =>
      _$RequestFieldFromJson(json);

  Map<String, dynamic> toJson() => _$RequestFieldToJson(this);
}
