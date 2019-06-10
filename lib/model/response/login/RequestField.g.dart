// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RequestField.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestField _$RequestFieldFromJson(Map<String, dynamic> json) {
  return RequestField(
      json['type'] as String, json['label'] as String, json['help'] as String);
}

Map<String, dynamic> _$RequestFieldToJson(RequestField instance) =>
    <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'help': instance.help
    };
