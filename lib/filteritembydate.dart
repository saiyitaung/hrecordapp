import 'package:flutter/material.dart';
import './entities/item.dart';
import './utils/utils.dart';

class FilterItemsByDate extends StatelessWidget {
  final List<Item> items;
  final DateTime date;
  FilterItemsByDate({this.items, this.date});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${fmtDate(date)}"),
      ),
      body: Column(children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  child: Text(
                    "Total count",
                    // textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  child: Text(
                    "${totalNeedToHelp(items)}",
                    // textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        Expanded(
            child: items.length == 0
                ? Center(
                    child: Text("Empty"),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(
                          "${items[index].name}",
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: CircleAvatar(
                          child: Text(
                            "${totalHelpCount(items[index].needToHelpBack)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    itemCount: items.length,
                  )),
      ]),
    );
  }
}
