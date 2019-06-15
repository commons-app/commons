// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NearbyResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyResponse _$NearbyResponseFromJson(Map json) {
  return $checkedNew('NearbyResponse', json, () {
    final val = NearbyResponse(
        results: $checkedConvert(
            json,
            'results',
            (v) => v == null
                ? null
                : NearbyResults.fromJson((v as Map)?.map(
                    (k, e) => MapEntry(k as String, e),
                  ))));
    return val;
  });
}

Map<String, dynamic> _$NearbyResponseToJson(NearbyResponse instance) =>
    <String, dynamic>{'results': instance.results};
