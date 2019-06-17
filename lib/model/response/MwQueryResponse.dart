import 'package:json_annotation/json_annotation.dart';
import 'MwQueryResult.dart';
import 'MwResponse.dart';
import 'MwServiceError.dart';

part 'MwQueryResponse.g.dart';

@JsonSerializable()
class MwQueryResponse extends MwResponse {
  @JsonKey(name: "batchcomplete")
  final bool batchComplete;
  @JsonKey(name: "continue")
  final Map<String, String> continuation;
  final MwQueryResult query;

  MwQueryResponse(List<MwServiceError> errors, String servedBy, this.batchComplete, this.continuation, this.query) : super(errors, servedBy);

  MwQueryResult getMwQueryResult() {
    return query;
  }

  bool success() {
    return this.query != null;
  }

  factory MwQueryResponse.fromJson(Map<String, dynamic> json) => _$MwQueryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MwQueryResponseToJson(this);
}
