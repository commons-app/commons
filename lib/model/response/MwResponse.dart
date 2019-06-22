import 'package:json_annotation/json_annotation.dart';
import 'MwServiceError.dart';

part 'MwResponse.g.dart';

@JsonSerializable()
class MwResponse {
  List<MwServiceError> errors;
  String servedBy;

  MwResponse({this.errors, this.servedBy});

  factory MwResponse.fromJson(Map<String, dynamic> json) => _$MwResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MwResponseToJson(this);
}
