import 'package:json_annotation/json_annotation.dart';
import 'RequestField.dart';

part 'LoginRequest.g.dart';

@JsonSerializable()
class LoginRequest {
  String id;
  String required;
  String provider;
  String account;
  Map<String, RequestField> fields;

  LoginRequest(this.id, this.required, this.provider, this.account, this.fields);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
