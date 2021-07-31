import 'package:hrecord/entities/item.dart';
import 'package:hrecord/entities/record.dart';

class ExportData {
  Record r;
  List<Item> items;
  ExportData(this.r, this.items);
  Map<String, dynamic> toJson() => {'record': this.r, 'helps': this.items};
}
