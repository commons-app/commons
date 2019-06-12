// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NearbyResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyResponse _$NearbyResponseFromJson(Map<String, dynamic> json) {
  return NearbyResponse(
      results: json['results'] == null
          ? null
          : NearbyResults.fromJson(json['results'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NearbyResponseToJson(NearbyResponse instance) =>
    <String, dynamic>{'results': instance.results};
