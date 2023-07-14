// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Story {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  String? createdAt;
  double? lat;
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

  Story copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    String? createdAt,
    double? lat,
    double? lon,
  }) {
    return Story(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lat': lat,
      'lon': lon,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      lon: map['lon'] != null ? map['lon'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Story(id: $id, name: $name, description: $description, photoUrl: $photoUrl, createdAt: $createdAt, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(covariant Story other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.lat == lat &&
        other.lon == lon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        photoUrl.hashCode ^
        createdAt.hashCode ^
        lat.hashCode ^
        lon.hashCode;
  }
}
