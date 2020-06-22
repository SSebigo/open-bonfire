// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trophy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrophyAdapter extends TypeAdapter<Trophy> {
  @override
  final typeId = 0;

  @override
  Trophy read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trophy(
      description: (fields[1] as Map)?.cast<String, String>(),
      iconUrl: fields[3] as String,
      id: fields[2] as String,
      title: (fields[0] as Map)?.cast<String, String>(),
      uniqueName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Trophy obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.iconUrl)
      ..writeByte(4)
      ..write(obj.uniqueName);
  }
}
