// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NearbyResultItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyResultItem _$NearbyResultItemFromJson(Map<String, dynamic> json) {
  return NearbyResultItem(
      json['item'] == null
          ? null
          : ResultTuple.fromJson(json['item'] as Map<String, dynamic>),
      json['wikipediaArticle'] == null
          ? null
          : ResultTuple.fromJson(
              json['wikipediaArticle'] as Map<String, dynamic>),
      json['commonsArticle'] == null
          ? null
          : ResultTuple.fromJson(
              json['commonsArticle'] as Map<String, dynamic>),
      json['location'] == null
          ? null
          : ResultTuple.fromJson(json['location'] as Map<String, dynamic>),
      json['label'] == null
          ? null
          : ResultTuple.fromJson(json['label'] as Map<String, dynamic>),
      json['class'] == null
          ? null
          : ResultTuple.fromJson(json['class'] as Map<String, dynamic>),
      json['classLabel'] == null
          ? null
          : ResultTuple.fromJson(json['classLabel'] as Map<String, dynamic>),
      json['commonsCategory'] == null
          ? null
          : ResultTuple.fromJson(
              json['commonsCategory'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NearbyResultItemToJson(NearbyResultItem instance) =>
    <String, dynamic>{
      'item': instance.item,
      'wikipediaArticle': instance.wikipediaArticle,
      'commonsArticle': instance.commonsArticle,
      'location': instance.location,
      'label': instance.label,
      'class': instance.className,
      'classLabel': instance.classLabel,
      'commonsCategory': instance.commonsCategory
    };
