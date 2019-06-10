// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClientLogin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientLogin _$ClientLoginFromJson(Map<String, dynamic> json) {
  return ClientLogin(json['status'] as String, json['requests'] as List,
      json['message'] as String, json['userName'] as String);
}

Map<String, dynamic> _$ClientLoginToJson(ClientLogin instance) =>
    <String, dynamic>{
      'status': instance.status,
      'requests': instance.requests,
      'message': instance.message,
      'userName': instance.userName
    };
