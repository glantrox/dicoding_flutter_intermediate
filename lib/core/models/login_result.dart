import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  @JsonKey(name: 'user')
  String? user;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'token')
  String? token;
  LoginResult({
    this.user,
    this.name,
    this.token,
  });
  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
