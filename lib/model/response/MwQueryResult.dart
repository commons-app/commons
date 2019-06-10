import 'package:json_annotation/json_annotation.dart';
import 'Tokens.dart';

part 'MwQueryResult.g.dart';

@JsonSerializable()
class MwQueryResult {
  Tokens tokens;

  MwQueryResult(this.tokens);

  Tokens getTokens() {
    return tokens;
  }

  factory MwQueryResult.fromJson(Map<String, dynamic> json) => _$MwQueryResultFromJson(json);

  Map<String, dynamic> toJson() => _$MwQueryResultToJson(this);
}
