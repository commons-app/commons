import 'package:json_annotation/json_annotation.dart';
part 'Tokens.g.dart';

@JsonSerializable()
class Tokens {
  String csrftoken;
  String createaccounttoken;
  String logintoken;

  Tokens(this.csrftoken, this.createaccounttoken, this.logintoken);

  String getCsrf() {
    return csrftoken;
  }

  String createAccount() {
    return createaccounttoken;
  }

  String login() {
    return logintoken;
  }

  factory Tokens.fromJson(Map<String, dynamic> json) => _$TokensFromJson(json);

  Map<String, dynamic> toJson() => _$TokensToJson(this);
}
