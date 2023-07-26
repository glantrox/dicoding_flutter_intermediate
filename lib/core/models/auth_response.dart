// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'login_result.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'error')
  bool? error;
  @JsonKey(name: 'loginResult')
  LoginResult? loginResult;
  AuthResponse({
    this.message,
    this.error,
    this.loginResult,
  });

  factory AuthResponse.fromJson(json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
