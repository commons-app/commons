import 'package:json_annotation/json_annotation.dart';
import 'MwQueryResult.dart';
import 'MwResponse.dart';
import 'MwServiceError.dart';

part 'MwQueryResponse.g.dart';

@JsonSerializable()
class MwQueryResponse extends MwResponse {
  final MwQueryResult query;

  MwQueryResponse(List<MwServiceError> errors, String servedBy, this.query) : super(errors, servedBy);

  MwQueryResult getMwQueryResult() {
    return query;
  }

  factory MwQueryResponse.fromJson(Map<String, dynamic> json) => _$MwQueryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MwQueryResponseToJson(this);
}
