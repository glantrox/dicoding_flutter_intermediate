// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddResponse {
  bool? error;
  String? message;
  AddResponse({
    this.error,
    this.message,
  });

  AddResponse copyWith({
    bool? error,
    String? message,
  }) {
    return AddResponse(
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
    };
  }

  factory AddResponse.fromMap(Map<String, dynamic> map) {
    return AddResponse(
      error: map['error'] != null ? map['error'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddResponse.fromJson(String source) =>
      AddResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddResponse(error: $error, message: $message)';

  @override
  bool operator ==(covariant AddResponse other) {
    if (identical(this, other)) return true;

    return other.error == error && other.message == message;
  }

  @override
  int get hashCode => error.hashCode ^ message.hashCode;
}
