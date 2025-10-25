// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noise_measurement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoiseMeasurementAdapter extends TypeAdapter<NoiseMeasurement> {
  @override
  final int typeId = 3;

  @override
  NoiseMeasurement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoiseMeasurement(
      id: fields[0] as String,
      decibelLevel: fields[1] as double,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      timestamp: fields[4] as DateTime,
      type: fields[5] as MeasurementType,
      status: fields[6] as MeasurementStatus,
      venueId: fields[7] as String?,
      userId: fields[8] as String?,
      metadata: (fields[9] as Map).cast<String, dynamic>(),
    )
      ..createdAt = fields[10] as DateTime
      ..updatedAt = fields[11] as DateTime;
  }

  @override
  void write(BinaryWriter writer, NoiseMeasurement obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.decibelLevel)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.venueId)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoiseMeasurementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasurementTypeAdapter extends TypeAdapter<MeasurementType> {
  @override
  final int typeId = 0;

  @override
  MeasurementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeasurementType.passive;
      case 1:
        return MeasurementType.active;
      case 2:
        return MeasurementType.venue;
      default:
        return MeasurementType.passive;
    }
  }

  @override
  void write(BinaryWriter writer, MeasurementType obj) {
    switch (obj) {
      case MeasurementType.passive:
        writer.writeByte(0);
        break;
      case MeasurementType.active:
        writer.writeByte(1);
        break;
      case MeasurementType.venue:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasurementStatusAdapter extends TypeAdapter<MeasurementStatus> {
  @override
  final int typeId = 1;

  @override
  MeasurementStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeasurementStatus.pending;
      case 1:
        return MeasurementStatus.uploaded;
      case 2:
        return MeasurementStatus.failed;
      default:
        return MeasurementStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, MeasurementStatus obj) {
    switch (obj) {
      case MeasurementStatus.pending:
        writer.writeByte(0);
        break;
      case MeasurementStatus.uploaded:
        writer.writeByte(1);
        break;
      case MeasurementStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoiseLevelAdapter extends TypeAdapter<NoiseLevel> {
  @override
  final int typeId = 2;

  @override
  NoiseLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoiseLevel.veryQuiet;
      case 1:
        return NoiseLevel.quiet;
      case 2:
        return NoiseLevel.moderate;
      case 3:
        return NoiseLevel.loud;
      case 4:
        return NoiseLevel.veryLoud;
      case 5:
        return NoiseLevel.extremelyLoud;
      default:
        return NoiseLevel.veryQuiet;
    }
  }

  @override
  void write(BinaryWriter writer, NoiseLevel obj) {
    switch (obj) {
      case NoiseLevel.veryQuiet:
        writer.writeByte(0);
        break;
      case NoiseLevel.quiet:
        writer.writeByte(1);
        break;
      case NoiseLevel.moderate:
        writer.writeByte(2);
        break;
      case NoiseLevel.loud:
        writer.writeByte(3);
        break;
      case NoiseLevel.veryLoud:
        writer.writeByte(4);
        break;
      case NoiseLevel.extremelyLoud:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoiseLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
