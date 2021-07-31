import 'package:flutter/material.dart';
import './entities/record.dart';
import './recorddetail.dart';
import './utils/utils.dart' as utils;

class FilterRecord extends StatelessWidget {
  final String title;
  final List<Record> records;
  FilterRecord({@required this.title, @required this.records});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: TextStyle(fontFamily: "Padauk"),),
      ),
      body: records.length > 0
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(records[index].name),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordDetail(
                                  r: records[index],
                                )));
                  },
                  leading: Container(
                                    width: 45,
                                    height: 45,
                                    child: Image(
                                      fit: BoxFit.scaleDown,
                                      image: AssetImage("img/file.png"),
                                    ),
                                  ),
                  subtitle: Text("${utils.fmtDate(records[index].timeStamp)}"),
                );
              },
              itemCount: records.length,
            )
          : Center(child: Text("Empty!")),
    );
  }
}
