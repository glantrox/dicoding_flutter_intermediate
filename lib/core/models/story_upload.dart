import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StoryUpload {
  String? description;
  File? photo;
  double? lat;
  double? lon;
  StoryUpload(
      {required this.description, required this.photo, this.lat, this.lon});
}
