import 'dart:io';

class StoryUpload {
  String? description;
  File? photo;
  double? lat;
  double? lon;
  StoryUpload(
      {required this.description, required this.photo, this.lat, this.lon});
}
