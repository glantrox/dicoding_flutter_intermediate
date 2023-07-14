// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:submission_intermediate/core/models/story.dart';

class StoryDetailResponse {
  bool? error;
  String? message;
  Story? story;
  StoryDetailResponse({
    this.error,
    this.message,
    this.story,
  });

  StoryDetailResponse copyWith({
    bool? error,
    String? message,
    Story? story,
  }) {
    return StoryDetailResponse(
      error: error ?? this.error,
      message: message ?? this.message,
      story: story ?? this.story,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'story': story?.toMap(),
    };
  }

  factory StoryDetailResponse.fromMap(Map<String, dynamic> map) {
    return StoryDetailResponse(
      error: map['error'] != null ? map['error'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
      story: map['story'] != null
          ? Story.fromMap(map['story'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryDetailResponse.fromJson(String source) =>
      StoryDetailResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StoryDetailResponse(error: $error, message: $message, story: $story)';

  @override
  bool operator ==(covariant StoryDetailResponse other) {
    if (identical(this, other)) return true;

    return other.error == error &&
        other.message == message &&
        other.story == story;
  }

  @override
  int get hashCode => error.hashCode ^ message.hashCode ^ story.hashCode;
}
