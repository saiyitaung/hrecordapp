import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class Help {
  @HiveField(0)
  String id;
  @HiveField(1)
  String detail;
  @HiveField(2)
  DateTime timeStamp;
  @HiveField(3)
  int count;
  
  Help({this.id,this.detail,this.timeStamp,this.count});
}
