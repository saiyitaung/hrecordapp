import 'package:hive/hive.dart';

import './help.dart';
import './pay.dart';

@HiveType(typeId: 3)
class Item {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  //other
  @HiveField(2)
  List<Help> needToHelpBack;
  //us
  @HiveField(3)
  List<Help> gettingHelp;

  @HiveField(4)
  DateTime created;
  @HiveField(5)
  bool isfinished;
  @HiveField(6)
  Pay paid;
  Item(
      {this.id,
      this.name,
      this.created,
      this.gettingHelp,
      this.needToHelpBack,
      this.isfinished = false,
      this.paid});
  Item.fronJson(Map<String, dynamic> data)
      : this.id = data['id'],
        this.name = data['name'],
        this.needToHelpBack = [],
        this.gettingHelp = [],
        this.created = DateTime.parse(data['created']),
        this.isfinished = data['isfinished'],
        this.paid = Pay.fronJson(data['paid']);
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'needToHelpBack': this.needToHelpBack,
        'gettingHelp': this.gettingHelp,
        'created': this.created.toIso8601String(),
        'isfinished': this.isfinished,
        'paid': this.paid
      };
}
