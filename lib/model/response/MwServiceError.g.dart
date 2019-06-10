// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MwServiceError.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MwServiceError _$MwServiceErrorFromJson(Map<String, dynamic> json) {
  return MwServiceError(
      json['code'] as String,
      json['text'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MwServiceErrorToJson(MwServiceError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
      'data': instance.data
    };
