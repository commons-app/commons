import 'package:json_annotation/json_annotation.dart';
import 'ClientLogin.dart';
import 'package:commons/model/response/MwServiceError.dart';

part 'LoginResponse.g.dart';

@JsonSerializable()
class LoginResponse {
  MwServiceError error;
  ClientLogin clientLogin;

  LoginResponse(this.error, this.clientLogin);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
