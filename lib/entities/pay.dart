import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class Pay{
  @HiveField(0)
  int count;
  @HiveField(1)
  double price;
  Pay({this.count,this.price});
}