import 'package:hive/hive.dart';

part 'noise_measurement.g.dart';

@HiveType(typeId: 0)
enum MeasurementType {
  @HiveField(0)
  passive,
  @HiveField(1)
  active,
  @HiveField(2)
  venue,
}

@HiveType(typeId: 1)
enum MeasurementStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  uploaded,
  @HiveField(2)
  failed,
}

@HiveType(typeId: 2)
enum NoiseLevel {
  @HiveField(0)
  veryQuiet,
  @HiveField(1)
  quiet,
  @HiveField(2)
  moderate,
  @HiveField(3)
  loud,
  @HiveField(4)
  veryLoud,
  @HiveField(5)
  extremelyLoud,
}

@HiveType(typeId: 3)
class NoiseMeasurement extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double decibelLevel;

  @HiveField(2)
  late double latitude;

  @HiveField(3)
  late double longitude;

  @HiveField(4)
  late DateTime timestamp;

  @HiveField(5)
  late MeasurementType type;

  @HiveField(6)
  late MeasurementStatus status;

  @HiveField(7)
  late String? venueId;

  @HiveField(8)
  late String? userId;

  @HiveField(9)
  late Map<String, dynamic> metadata;

  @HiveField(10)
  late DateTime createdAt;

  @HiveField(11)
  late DateTime updatedAt;

  NoiseMeasurement({
    required this.id,
    required this.decibelLevel,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.type,
    this.status = MeasurementStatus.pending,
    this.venueId,
    this.userId,
    this.metadata = const {},
    DateTime? createdAtParam,
    DateTime? updatedAtParam,
  }) {
    createdAt = createdAtParam ?? DateTime.now();
    updatedAt = updatedAtParam ?? DateTime.now();
  }

  factory NoiseMeasurement.fromJson(Map<String, dynamic> json) {
    return NoiseMeasurement(
      id: json['id'] as String,
      decibelLevel: (json['decibelLevel'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MeasurementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: MeasurementStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      venueId: json['venueId'] as String?,
      userId: json['userId'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAtParam: DateTime.parse(json['createdAt'] as String),
      updatedAtParam: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'decibelLevel': decibelLevel,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'venueId': venueId,
      'userId': userId,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  NoiseMeasurement copyWith({
    String? id,
    double? decibelLevel,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    MeasurementType? type,
    MeasurementStatus? status,
    String? venueId,
    String? userId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoiseMeasurement(
      id: id ?? this.id,
      decibelLevel: decibelLevel ?? this.decibelLevel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      venueId: venueId ?? this.venueId,
      userId: userId ?? this.userId,
      metadata: metadata ?? this.metadata,
      createdAtParam: createdAt ?? this.createdAt,
      updatedAtParam: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NoiseMeasurement(id: $id, decibelLevel: $decibelLevel, latitude: $latitude, longitude: $longitude, timestamp: $timestamp, type: $type, status: $status, venueId: $venueId, userId: $userId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoiseMeasurement &&
        other.id == id &&
        other.decibelLevel == decibelLevel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.status == status &&
        other.venueId == venueId &&
        other.userId == userId &&
        other.metadata == metadata &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        decibelLevel.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        timestamp.hashCode ^
        type.hashCode ^
        status.hashCode ^
        venueId.hashCode ^
        userId.hashCode ^
        metadata.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
