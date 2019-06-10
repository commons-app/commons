// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data((json['messages'] as List)
      ?.map(
          (e) => e == null ? null : Message.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'messages': instance.messages};
