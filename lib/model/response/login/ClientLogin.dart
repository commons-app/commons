import 'package:json_annotation/json_annotation.dart';
import 'LoginRequest.dart';

part 'ClientLogin.g.dart';

@JsonSerializable()
class ClientLogin {
  String status;
  List<LoginRequest> requests;
  String message;
  String userName;

  ClientLogin(this.status, this.requests, this.message, this.userName);

  factory ClientLogin.fromJson(Map<String, dynamic> json) =>
      _$ClientLoginFromJson(json);

  Map<String, dynamic> toJson() => _$ClientLoginToJson(this);
}
