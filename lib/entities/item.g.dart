import 'package:hive/hive.dart';
import './item.dart';
import './help.dart';
import './pay.dart';
class ItemAdapter extends TypeAdapter<Item> {
  final typeId = 3;
  Item read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item()
    ..id =fields[0] as String
    ..name = fields[1] as String
    ..needToHelpBack = (fields[2] as List)?.cast<Help>()
    ..gettingHelp = (fields[3] as List)?.cast<Help>()
    ..created = fields[4] as DateTime
    ..isfinished = fields[5] as bool
    ..paid =fields[6] as Pay;
  }

  void write(BinaryWriter writer, Item obj) {
    writer
    ..writeByte(7)
    ..writeByte(0)
    ..write(obj.id)
    ..writeByte(1)
    ..write(obj.name)
    ..writeByte(2)
    ..write(obj.needToHelpBack)
    ..writeByte(3)
    ..write(obj.gettingHelp)
    ..writeByte(4)
    ..write(obj.created)
    ..writeByte(5)
    ..write(obj.isfinished)
    ..writeByte(6)
    ..write(obj.paid);
  }
}
