// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BmiAdapter extends TypeAdapter<Bmi> {
  @override
  final int typeId = 1;

  @override
  Bmi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bmi(
      fields[0] as DateTime,
      fields[1] as double,
      fields[2] as double,
      fields[3] as double,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Bmi obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.bmi)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BmiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
