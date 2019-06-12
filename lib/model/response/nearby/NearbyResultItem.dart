import 'package:commons/model/response/nearby/ResultTuple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NearbyResultItem.g.dart';

@JsonSerializable()
class NearbyResultItem {
  final ResultTuple item;
  final ResultTuple wikipediaArticle;
  final ResultTuple commonsArticle;
  final ResultTuple location;
  final ResultTuple label;
  @JsonKey(name:"class")
  final ResultTuple className;
  final ResultTuple classLabel;
  final ResultTuple commonsCategory;

  NearbyResultItem(
      this.item,
      this.wikipediaArticle,
      this.commonsArticle,
      this.location,
      this.label,
      this.className,
      this.classLabel,
      this.commonsCategory);

  ResultTuple getItem() {
    return (item == null) ? new ResultTuple("", "") : item;
  }

  ResultTuple getWikipediaArticle() {
    return (wikipediaArticle == null)
        ? new ResultTuple("", "")
        : wikipediaArticle;
  }

  ResultTuple getCommonsArticle() {
    return (commonsArticle == null) ? new ResultTuple("", "") : commonsArticle;
  }

  ResultTuple getLocation() {
    return (location == null) ? new ResultTuple("", "") : location;
  }

  ResultTuple getLabel() {
    return (label == null) ? new ResultTuple("", "") : label;
  }

  ResultTuple getClassName() {
    return (className == null) ? new ResultTuple("", "") : className;
  }

  ResultTuple getClassLabel() {
    return (classLabel == null) ? new ResultTuple("", "") : classLabel;
  }

  ResultTuple getCommonsCategory() {
    return (commonsCategory == null)
        ? new ResultTuple("", "")
        : commonsCategory;
  }

  factory NearbyResultItem.fromJson(Map<String, dynamic> json) => _$NearbyResultItemFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyResultItemToJson(this);
}
