
import 'package:hive/hive.dart';
import './help.dart';

class HelpAdapter extends TypeAdapter<Help>{
  final typeId=4;
  Help read(BinaryReader reader){
 var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Help()
    ..id = fields[0] as String
    ..detail = fields[1] as String
    ..timeStamp = fields[2] as DateTime
    ..count = fields[3] as int;
  }
  void write(BinaryWriter writer,Help h){
    writer
    ..writeByte(4)
    ..writeByte(0)
    ..write(h.id)
    ..writeByte(1)
    ..write(h.detail)
    ..writeByte(2)
    ..write(h.timeStamp)
    ..writeByte(3)
    ..write(h.count);
  }
}