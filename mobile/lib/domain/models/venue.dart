import 'package:hive/hive.dart';

part 'venue.g.dart';

@HiveType(typeId: 5)
enum VenueType {
  @HiveField(0)
  restaurant,
  @HiveField(1)
  cafe,
  @HiveField(2)
  bar,
  @HiveField(3)
  hotel,
  @HiveField(4)
  library,
  @HiveField(5)
  office,
  @HiveField(6)
  retail,
  @HiveField(7)
  entertainment,
  @HiveField(8)
  other,
}

@HiveType(typeId: 6)
class Venue extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String address;

  @HiveField(3)
  late double latitude;

  @HiveField(4)
  late double longitude;

  @HiveField(5)
  late VenueType type;

  @HiveField(6)
  late List<String> tags;

  @HiveField(7)
  late double averageNoiseLevel;

  @HiveField(8)
  late int totalMeasurements;

  @HiveField(9)
  late DateTime lastMeasurement;

  @HiveField(10)
  late Map<String, dynamic> metadata;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  late DateTime updatedAt;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.tags = const [],
    this.averageNoiseLevel = 0.0,
    this.totalMeasurements = 0,
    DateTime? lastMeasurementParam,
    this.metadata = const {},
    DateTime? createdAtParam,
    DateTime? updatedAtParam,
  }) {
    lastMeasurement = lastMeasurementParam ?? DateTime.now();
    createdAt = createdAtParam ?? DateTime.now();
    updatedAt = updatedAtParam ?? DateTime.now();
  }

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: VenueType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      averageNoiseLevel: (json['averageNoiseLevel'] as num?)?.toDouble() ?? 0.0,
      totalMeasurements: json['totalMeasurements'] as int? ?? 0,
      lastMeasurementParam: DateTime.parse(json['lastMeasurement'] as String),
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : {},
      createdAtParam: DateTime.parse(json['createdAt'] as String),
      updatedAtParam: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toString().split('.').last,
      'tags': tags,
      'averageNoiseLevel': averageNoiseLevel,
      'totalMeasurements': totalMeasurements,
      'lastMeasurement': lastMeasurement.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Venue copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    VenueType? type,
    List<String>? tags,
    double? averageNoiseLevel,
    int? totalMeasurements,
    DateTime? lastMeasurement,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      averageNoiseLevel: averageNoiseLevel ?? this.averageNoiseLevel,
      totalMeasurements: totalMeasurements ?? this.totalMeasurements,
      lastMeasurementParam: lastMeasurement ?? this.lastMeasurement,
      metadata: metadata ?? this.metadata,
      createdAtParam: createdAt ?? this.createdAt,
      updatedAtParam: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, type: $type, tags: $tags, averageNoiseLevel: $averageNoiseLevel, totalMeasurements: $totalMeasurements, lastMeasurement: $lastMeasurement, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Venue &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.type == type &&
        other.tags == tags &&
        other.averageNoiseLevel == averageNoiseLevel &&
        other.totalMeasurements == totalMeasurements &&
        other.lastMeasurement == lastMeasurement &&
        other.metadata == metadata &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        type.hashCode ^
        tags.hashCode ^
        averageNoiseLevel.hashCode ^
        totalMeasurements.hashCode ^
        lastMeasurement.hashCode ^
        metadata.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
