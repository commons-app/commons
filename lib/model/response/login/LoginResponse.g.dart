// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
      json['error'] == null
          ? null
          : MwServiceError.fromJson(json['error'] as Map<String, dynamic>),
      json['clientlogin'] == null
          ? null
          : ClientLogin.fromJson(json['clientlogin'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'clientlogin': instance.clientlogin
    };
