import 'package:commons/model/response/nearby/NearbyResultItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NearbyResults.g.dart';

@JsonSerializable()
class NearbyResults {
  final List<NearbyResultItem> bindings;

  NearbyResults(this.bindings);

  List<NearbyResultItem> getBindings() {
    return bindings;
  }

  factory NearbyResults.fromJson(Map<String, dynamic> json) => _$NearbyResultsFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyResultsToJson(this);
}
