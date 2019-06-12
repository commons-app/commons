import 'package:json_annotation/json_annotation.dart';

part 'ResultTuple.g.dart';

@JsonSerializable()
class ResultTuple {
  final String type;
  final String value;

  ResultTuple(this.type, this.value);

  String getType() {
    return type;
  }

  String getValue() {
    return value;
  }

  factory ResultTuple.fromJson(Map<String, dynamic> json) => _$ResultTupleFromJson(json);

  Map<String, dynamic> toJson() => _$ResultTupleToJson(this);
}
