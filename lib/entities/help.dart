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

  Help({this.id, this.detail, this.timeStamp, this.count});
  Help.fronJson(Map<String, dynamic> d)
      : this.id = d['id'],
        this.detail = d['detail'],
        this.timeStamp = DateTime.parse(d['timeStamp']),
        this.count = d['count'];
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'detail': this.detail,
        'timeStamp': this.timeStamp.toIso8601String(),
        'count': this.count
      };
}
