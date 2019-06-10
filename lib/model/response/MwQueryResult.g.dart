// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MwQueryResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MwQueryResult _$MwQueryResultFromJson(Map<String, dynamic> json) {
  return MwQueryResult(json['tokens'] == null
      ? null
      : Tokens.fromJson(json['tokens'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MwQueryResultToJson(MwQueryResult instance) =>
    <String, dynamic>{'tokens': instance.tokens};
