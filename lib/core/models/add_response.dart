// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';
part 'add_response.g.dart';

@JsonSerializable()
class AddResponse {
  @JsonKey(name: "error")
  bool? error;
  @JsonKey(name: "message")
  String? message;
  AddResponse({
    this.error,
    this.message,
  });
  factory AddResponse.fromJson(json) => _$AddResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddResponseToJson(this);
}
