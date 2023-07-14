// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:submission_intermediate/core/models/story.dart';

class StoryListResponse {
  bool? error;
  String? message;
  List<Story>? listStory;
  StoryListResponse({
    this.error,
    this.message,
    this.listStory,
  });

  StoryListResponse copyWith({
    bool? error,
    String? message,
    List<Story>? listStory,
  }) {
    return StoryListResponse(
      error: error ?? this.error,
      message: message ?? this.message,
      listStory: listStory ?? this.listStory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'listStory': listStory?.map((x) => x.toMap()).toList(),
    };
  }

  factory StoryListResponse.fromMap(Map<String, dynamic> map) {
    return StoryListResponse(
      error: map['error'] != null ? map['error'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
      listStory: map['listStory'] != null
          ? List<Story>.from(
              (map['listStory'] as List<dynamic>).map<Story?>(
                (x) => Story.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryListResponse.fromJson(String source) =>
      StoryListResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StoryListResponse(error: $error, message: $message, listStory: $listStory)';

  @override
  bool operator ==(covariant StoryListResponse other) {
    if (identical(this, other)) return true;

    return other.error == error &&
        other.message == message &&
        listEquals(other.listStory, listStory);
  }

  @override
  int get hashCode => error.hashCode ^ message.hashCode ^ listStory.hashCode;
}
