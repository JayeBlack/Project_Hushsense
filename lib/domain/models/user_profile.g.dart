// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 4;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      profilePictureUrl: fields[4] as String?,
      totalMeasurements: fields[5] as int,
      totalRewards: fields[6] as int,
      level: fields[7] as int,
      experiencePoints: fields[8] as double,
      badges: (fields[9] as List).cast<String>(),
      preferences: (fields[10] as Map).cast<String, dynamic>(),
      isPremium: fields[11] as bool,
    )
      ..lastActive = fields[12] as DateTime
      ..createdAt = fields[13] as DateTime
      ..updatedAt = fields[14] as DateTime;
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profilePictureUrl)
      ..writeByte(5)
      ..write(obj.totalMeasurements)
      ..writeByte(6)
      ..write(obj.totalRewards)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.experiencePoints)
      ..writeByte(9)
      ..write(obj.badges)
      ..writeByte(10)
      ..write(obj.preferences)
      ..writeByte(11)
      ..write(obj.isPremium)
      ..writeByte(12)
      ..write(obj.lastActive)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
