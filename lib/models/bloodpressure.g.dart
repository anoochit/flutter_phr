// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloodpressure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BloodPressureAdapter extends TypeAdapter<BloodPressure> {
  @override
  final int typeId = 0;

  @override
  BloodPressure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BloodPressure(
      fields[0] as DateTime,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
      (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BloodPressure obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.systolic)
      ..writeByte(2)
      ..write(obj.diastolic)
      ..writeByte(3)
      ..write(obj.pulse)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodPressureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
