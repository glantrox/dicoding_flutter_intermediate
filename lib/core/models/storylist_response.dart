// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:submission_intermediate/core/models/story.dart';
import 'package:json_annotation/json_annotation.dart';
part 'storylist_response.g.dart';

@JsonSerializable()
class StoryListResponse {
  @JsonKey(name: 'error')
  bool? error;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'listStory')
  List<Story>? listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(json) => _$StoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryListResponseToJson(this);
}
