// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MwQueryResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MwQueryResult _$MwQueryResultFromJson(Map<String, dynamic> json) {
  return MwQueryResult(
      json['tokens'] == null
          ? null
          : Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
      (json['search'] as List)
          ?.map((e) => e == null
              ? null
              : SearchResultItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MwQueryResultToJson(MwQueryResult instance) =>
    <String, dynamic>{'search': instance.search, 'tokens': instance.tokens};
