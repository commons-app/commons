import 'package:json_annotation/json_annotation.dart';
import 'Message.dart';
import 'Data.dart';
import 'ServiceError.dart';

part 'MwServiceError.g.dart';

@JsonSerializable()
class MwServiceError implements ServiceError {
  String code;
  String text;
  Data data;

  MwServiceError(this.code, this.text, this.data);

  @override
  String getDetails() {
    return text;
  }

  @override
  String getTitle() {
    return code;
  }

  factory MwServiceError.fromJson(Map<String, dynamic> json) => _$MwServiceErrorFromJson(json);

  Map<String, dynamic> toJson() => _$MwServiceErrorToJson(this);
}
