import 'package:commons/model/response/search/SearchResultItem.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Tokens.dart';
import 'category/GeoSearch.dart';
import 'media/ImageInfo.dart';
import 'media/contributions.dart';

part 'MwQueryResult.g.dart';

@JsonSerializable()
class MwQueryResult {
  List<SearchResultItem> search;
  List<ImageInfo> imageinfo;
  List<AllImages> allimages;
  List<GeoSearch> geosearch;
  Tokens tokens;

  MwQueryResult(this.tokens, this.search);

  Tokens getTokens() {
    return tokens;
  }

  factory MwQueryResult.fromJson(Map<String, dynamic> json) => _$MwQueryResultFromJson(json);

  Map<String, dynamic> toJson() => _$MwQueryResultToJson(this);
}
