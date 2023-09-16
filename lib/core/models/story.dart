// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'photoUrl')
  String? photoUrl;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'lat')
  double? lat;
  @JsonKey(name: 'lon')
  double? lon;
  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
