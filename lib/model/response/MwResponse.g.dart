// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MwResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MwResponse _$MwResponseFromJson(Map<String, dynamic> json) {
  return MwResponse(
      (json['errors'] as List)
          ?.map((e) => e == null
              ? null
              : MwServiceError.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['servedBy'] as String);
}

Map<String, dynamic> _$MwResponseToJson(MwResponse instance) =>
    <String, dynamic>{'errors': instance.errors, 'servedBy': instance.servedBy};
