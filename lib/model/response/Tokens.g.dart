// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tokens _$TokensFromJson(Map<String, dynamic> json) {
  return Tokens(json['csrftoken'] as String,
      json['createaccounttoken'] as String, json['logintoken'] as String);
}

Map<String, dynamic> _$TokensToJson(Tokens instance) => <String, dynamic>{
      'csrftoken': instance.csrftoken,
      'createaccounttoken': instance.createaccounttoken,
      'logintoken': instance.logintoken
    };
