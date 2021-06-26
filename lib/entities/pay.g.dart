import 'package:hive/hive.dart';
import './pay.dart';

class PayAdapter extends TypeAdapter<Pay> {
  final typeId = 5;
  Pay read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pay()
      ..count = fields[0] as int
      ..price = fields[1] as double;
  }

  void write(BinaryWriter writer, Pay p) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(p.count)
      ..writeByte(1)
      ..write(p.price);
  }
}
