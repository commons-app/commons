// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return LoginRequest(
      json['id'] as String,
      json['required'] as String,
      json['provider'] as String,
      json['account'] as String,
      (json['fields'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(
            k,
            e == null
                ? null
                : RequestField.fromJson(e as Map<String, dynamic>)),
      ));
}

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'required': instance.required,
      'provider': instance.provider,
      'account': instance.account,
      'fields': instance.fields
    };
