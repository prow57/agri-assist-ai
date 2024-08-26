// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanAdapter extends TypeAdapter<Scan> {
  @override
  final int typeId = 0;

  @override
  Scan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scan(
      plantName: fields[0] as String,
      commonName: fields[1] as String,
      disease: fields[2] as String,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Scan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.plantName)
      ..writeByte(1)
      ..write(obj.commonName)
      ..writeByte(2)
      ..write(obj.disease)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
