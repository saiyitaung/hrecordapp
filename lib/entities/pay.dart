import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class Pay {
  @HiveField(0)
  int count;
  @HiveField(1)
  double price;
  Pay({this.count, this.price});
  Pay.fronJson(Map<String, dynamic> d)
      : this.count = d['count'],
        this.price = d['price'];
  Map<String, dynamic> toJson() => {'count': this.count, 'price': this.price};
}
