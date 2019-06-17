// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MwQueryResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MwQueryResponse _$MwQueryResponseFromJson(Map<String, dynamic> json) {
  return MwQueryResponse(
      (json['errors'] as List)
          ?.map((e) => e == null
              ? null
              : MwServiceError.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['servedBy'] as String,
      json['batchcomplete'] as bool,
      (json['continue'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      json['query'] == null
          ? null
          : MwQueryResult.fromJson(json['query'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MwQueryResponseToJson(MwQueryResponse instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'servedBy': instance.servedBy,
      'batchcomplete': instance.batchComplete,
      'continue': instance.continuation,
      'query': instance.query
    };
