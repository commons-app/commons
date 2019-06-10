import 'package:json_annotation/json_annotation.dart';
import 'Message.dart';

part 'Data.g.dart';

@JsonSerializable()
class Data {
  List<Message> messages;

  Data(this.messages);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
