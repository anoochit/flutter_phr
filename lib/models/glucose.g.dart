// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlucoseAdapter extends TypeAdapter<Glucose> {
  @override
  final int typeId = 2;

  @override
  Glucose read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Glucose(
      fields[0] as DateTime,
      fields[1] as int,
      (fields[2] as List).cast<String>(),
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Glucose obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.tag)
      ..writeByte(3)
      ..write(obj.when)
      ..writeByte(4)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlucoseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
