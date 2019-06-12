// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientLogin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientLogin _$ClientLoginFromJson(Map<String, dynamic> json) {
  return ClientLogin(
      json['status'] as String,
      (json['requests'] as List)
          ?.map((e) => e == null
              ? null
              : LoginRequest.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['message'] as String,
      json['username'] as String);
}

Map<String, dynamic> _$ClientLoginToJson(ClientLogin instance) =>
    <String, dynamic>{
      'status': instance.status,
      'requests': instance.requests,
      'message': instance.message,
      'username': instance.username
    };
