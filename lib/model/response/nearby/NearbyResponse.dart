import 'package:commons/model/response/nearby/NearbyResults.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NearbyResponse.g.dart';

@JsonSerializable(
  anyMap: true,
  checked: true
)
class NearbyResponse {
  final NearbyResults results;

  NearbyResponse({this.results});

  NearbyResults getResults() {
    return results;
  }

  factory NearbyResponse.fromJson(Map<String, dynamic> json) => _$NearbyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyResponseToJson(this);
}
