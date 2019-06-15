import 'package:json_annotation/json_annotation.dart';

part 'SearchResultItem.g.dart';

@JsonSerializable()
class SearchResultItem {
  String title;

  SearchResultItem(this.title);

  factory SearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultItemToJson(this);
}
