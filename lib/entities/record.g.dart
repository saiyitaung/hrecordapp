import 'package:hive/hive.dart';
import './record.dart';

class RecordAdapter extends TypeAdapter<Record> {
  final typeId = 2;
  Record read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..timeStamp = fields[2] as DateTime
      ..totalGettingHelp = fields[3] as int
      ..totalNeedToHelp = fields[4] as int
      ..price = fields[5] as int
      ..helpType = fields[6] as String;
  }

  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.timeStamp)
      ..writeByte(3)
      ..write(obj.totalGettingHelp)
      ..writeByte(4)
      ..write(obj.totalNeedToHelp)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.helpType);
  }
}
