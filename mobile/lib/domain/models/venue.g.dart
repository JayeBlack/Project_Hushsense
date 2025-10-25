// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueAdapter extends TypeAdapter<Venue> {
  @override
  final int typeId = 6;

  @override
  Venue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Venue(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      type: fields[5] as VenueType,
      tags: (fields[6] as List).cast<String>(),
      averageNoiseLevel: fields[7] as double,
      totalMeasurements: fields[8] as int,
      metadata: (fields[10] as Map).cast<String, dynamic>(),
    )
      ..lastMeasurement = fields[9] as DateTime
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Venue obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.averageNoiseLevel)
      ..writeByte(8)
      ..write(obj.totalMeasurements)
      ..writeByte(9)
      ..write(obj.lastMeasurement)
      ..writeByte(10)
      ..write(obj.metadata)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VenueTypeAdapter extends TypeAdapter<VenueType> {
  @override
  final int typeId = 5;

  @override
  VenueType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VenueType.restaurant;
      case 1:
        return VenueType.cafe;
      case 2:
        return VenueType.bar;
      case 3:
        return VenueType.hotel;
      case 4:
        return VenueType.library;
      case 5:
        return VenueType.office;
      case 6:
        return VenueType.retail;
      case 7:
        return VenueType.entertainment;
      case 8:
        return VenueType.other;
      default:
        return VenueType.restaurant;
    }
  }

  @override
  void write(BinaryWriter writer, VenueType obj) {
    switch (obj) {
      case VenueType.restaurant:
        writer.writeByte(0);
        break;
      case VenueType.cafe:
        writer.writeByte(1);
        break;
      case VenueType.bar:
        writer.writeByte(2);
        break;
      case VenueType.hotel:
        writer.writeByte(3);
        break;
      case VenueType.library:
        writer.writeByte(4);
        break;
      case VenueType.office:
        writer.writeByte(5);
        break;
      case VenueType.retail:
        writer.writeByte(6);
        break;
      case VenueType.entertainment:
        writer.writeByte(7);
        break;
      case VenueType.other:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
