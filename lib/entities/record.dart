import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Record {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime timeStamp;
  @HiveField(3)
  int totalGettingHelp;
  @HiveField(4)
  int totalNeedToHelp;
  @HiveField(5)
  int price;
  @HiveField(6)
  String helpType;
  Record(
      {this.id,
      this.name,
      this.timeStamp,
      this.totalGettingHelp = 0,
      this.totalNeedToHelp = 0,
      this.helpType});
  Record.fronJson(Map<String, dynamic> data)
      : this.id = data['id'],
        this.name = data['name'],
        this.timeStamp =  DateTime.parse(data['timeStamp']),
        this.totalGettingHelp = data['totalGettingHelp'],
        this.totalNeedToHelp = data['totalNeedToHelp'],
        this.price = data['price'],
        this.helpType = data['helpType'];
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'timeStamp': this.timeStamp.toIso8601String(),
        'totalGettingHelp': this.totalGettingHelp,
        'totalNeedToHelp': this.totalNeedToHelp,
        'price': this.price,
        'helpType': this.helpType
      };
}
