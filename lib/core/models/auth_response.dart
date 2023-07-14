// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthResponse {
  String? message;
  bool? error;
  LoginResult? loginResult;
  AuthResponse({
    this.message,
    this.error,
    this.loginResult,
  });

  AuthResponse copyWith({
    String? message,
    bool? error,
    LoginResult? loginResult,
  }) {
    return AuthResponse(
      message: message ?? this.message,
      error: error ?? this.error,
      loginResult: loginResult ?? this.loginResult,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'error': error,
      'loginResult': loginResult?.toMap(),
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      message: map['message'] != null ? map['message'] as String : null,
      error: map['error'] != null ? map['error'] as bool : null,
      loginResult: map['loginResult'] != null
          ? LoginResult.fromMap(map['loginResult'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthResponse(message: $message, error: $error, loginResult: $loginResult)';

  @override
  bool operator ==(covariant AuthResponse other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.error == error &&
        other.loginResult == loginResult;
  }

  @override
  int get hashCode => message.hashCode ^ error.hashCode ^ loginResult.hashCode;
}

class LoginResult {
  String? user;
  String? name;
  String? token;
  LoginResult({
    this.user,
    this.name,
    this.token,
  });

  LoginResult copyWith({
    String? user,
    String? name,
    String? token,
  }) {
    return LoginResult(
      user: user ?? this.user,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'name': name,
      'token': token,
    };
  }

  factory LoginResult.fromMap(Map<String, dynamic> map) {
    return LoginResult(
      user: map['user'] != null ? map['user'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResult.fromJson(String source) =>
      LoginResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginResult(user: $user, name: $name, token: $token)';

  @override
  bool operator ==(covariant LoginResult other) {
    if (identical(this, other)) return true;

    return other.user == user && other.name == name && other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ name.hashCode ^ token.hashCode;
}
