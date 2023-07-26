// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:submission_intermediate/core/models/story.dart';

part 'storydetail_response.g.dart';

@JsonSerializable()
class StoryDetailResponse {
  @JsonKey(name: 'error')
  bool? error;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'story')
  Story? story;
  StoryDetailResponse({
    this.error,
    this.message,
    this.story,
  });
  factory StoryDetailResponse.fromJson(json) =>
      _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}
