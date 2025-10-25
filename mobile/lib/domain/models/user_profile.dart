import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 4)
class UserProfile extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String? email;

  @HiveField(3)
  late String? phoneNumber;

  @HiveField(4)
  late String? profilePictureUrl;

  @HiveField(5)
  late int totalMeasurements;

  @HiveField(6)
  late int totalRewards;

  @HiveField(7)
  late int level;

  @HiveField(8)
  late double experiencePoints;

  @HiveField(9)
  late List<String> badges;

  @HiveField(10)
  late Map<String, dynamic> preferences;

  @HiveField(11)
  late bool isPremium;

  @HiveField(12)
  late DateTime lastActive;

  @HiveField(13)
  late DateTime createdAt;

  @HiveField(14)
  late DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.totalMeasurements = 0,
    this.totalRewards = 0,
    this.level = 1,
    this.experiencePoints = 0.0,
    this.badges = const [],
    this.preferences = const {},
    this.isPremium = false,
    DateTime? lastActiveParam,
    DateTime? createdAtParam,
    DateTime? updatedAtParam,
  }) {
    lastActive = lastActiveParam ?? DateTime.now();
    createdAt = createdAtParam ?? DateTime.now();
    updatedAt = updatedAtParam ?? DateTime.now();
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      totalMeasurements: json['totalMeasurements'] as int? ?? 0,
      totalRewards: json['totalRewards'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      experiencePoints: (json['experiencePoints'] as num?)?.toDouble() ?? 0.0,
      badges: json['badges'] != null
          ? List<String>.from(json['badges'] as List)
          : [],
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(json['preferences'] as Map)
          : {},
      isPremium: json['isPremium'] as bool? ?? false,
      lastActiveParam: DateTime.parse(json['lastActive'] as String),
      createdAtParam: DateTime.parse(json['createdAt'] as String),
      updatedAtParam: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'totalMeasurements': totalMeasurements,
      'totalRewards': totalRewards,
      'level': level,
      'experiencePoints': experiencePoints,
      'badges': badges,
      'preferences': preferences,
      'isPremium': isPremium,
      'lastActive': lastActive.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    int? totalMeasurements,
    int? totalRewards,
    int? level,
    double? experiencePoints,
    List<String>? badges,
    Map<String, dynamic>? preferences,
    bool? isPremium,
    DateTime? lastActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      totalMeasurements: totalMeasurements ?? this.totalMeasurements,
      totalRewards: totalRewards ?? this.totalRewards,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      badges: badges ?? this.badges,
      preferences: preferences ?? this.preferences,
      isPremium: isPremium ?? this.isPremium,
      lastActiveParam: lastActive ?? this.lastActive,
      createdAtParam: createdAt ?? this.createdAt,
      updatedAtParam: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, username: $username, email: $email, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl, totalMeasurements: $totalMeasurements, totalRewards: $totalRewards, level: $level, experiencePoints: $experiencePoints, badges: $badges, preferences: $preferences, isPremium: $isPremium, lastActive: $lastActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.profilePictureUrl == profilePictureUrl &&
        other.totalMeasurements == totalMeasurements &&
        other.totalRewards == totalRewards &&
        other.level == level &&
        other.experiencePoints == experiencePoints &&
        other.badges == badges &&
        other.preferences == preferences &&
        other.isPremium == isPremium &&
        other.lastActive == lastActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        profilePictureUrl.hashCode ^
        totalMeasurements.hashCode ^
        totalRewards.hashCode ^
        level.hashCode ^
        experiencePoints.hashCode ^
        badges.hashCode ^
        preferences.hashCode ^
        isPremium.hashCode ^
        lastActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
