// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NearbyResults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyResults _$NearbyResultsFromJson(Map<String, dynamic> json) {
  return NearbyResults((json['bindings'] as List)
      ?.map((e) => e == null
          ? null
          : NearbyResultItem.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$NearbyResultsToJson(NearbyResults instance) =>
    <String, dynamic>{'bindings': instance.bindings};
