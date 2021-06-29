import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import './ui/totalhelpcountshow.dart';
import './entities/item.dart';
import './entities/help.dart';

class PaidChart extends StatelessWidget {
  final List<Item> items;
  final int price;
  PaidChart({this.items, this.price});

  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paid chart"),
      ),
      body: (paid(items) > 0 || received(items) > 0)
          ? Stack(
              children: [
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          TotalHelpShow(
                            title: "ႁဝ်းၵႃႇထႅမ်",
                            color: Colors.green,
                            // totalCount: utils.totalGettingHelp(items),
                            totalCount: totalReceivedCount(items),
                          ),
                          TotalHelpShow(
                            title: "မႃးထႅမ်ႁဝ်း",
                            color: Colors.red,
                            // totalCount: utils.totalNeedToHelp(items),
                            totalCount: totalPaidCount(items),
                          ),
                        ],
                      ),
                      height: 60,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                    ),
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1.98,
                        child: PieChart(
                          PieChartData(
                              // centerSpaceColor: Colors.yellow,
                              centerSpaceRadius: 0,
                              sectionsSpace: 1.0,
                              startDegreeOffset: 270,
                              sections: [
                                PieChartSectionData(
                                  titleStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  color: Colors.red.withOpacity(.7),
                                  radius: 80,
                                  // titlePositionPercentageOffset: 3,
                                  title:
                                      "( ${totalPaidCount(items)} )\n${paid(items)} ks",
                                  value: paid(items),
                                ),
                                PieChartSectionData(
                                  titleStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  color: Colors.green.withOpacity(.7),
                                  radius: 80,
                                  // titlePositionPercentageOffset: 3,
                                  title:
                                      "( ${totalReceivedCount(items)} )\n${received(items)} ks",
                                  value: received(items),
                                ),
                              ],
                              borderData: FlBorderData(show: false)),
                        ),
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  builder: (context, ctl) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0.0, -1.0),
                                color: Colors.black,
                                blurRadius: 1.0)
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(ctx).size.width / 2,
                              child: Text("Total Received",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.green)),
                            ),
                            Container(
                              width: MediaQuery.of(ctx).size.width / 2,
                              child: Text(
                                "${received(items).toInt()} Ks",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              padding: EdgeInsets.only(left: 20),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(ctx).size.width / 2,
                              child: Text("Total Paid",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.red)),
                            ),
                            Container(
                              width: MediaQuery.of(ctx).size.width / 2,
                              child: Text("-${paid(items).toInt()} Ks",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              padding: EdgeInsets.only(left: 20),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: paidItem(items).length > 4 ? ctl : null,
                            itemBuilder: (context, index) => Container(
                              child: ListTile(
                               
                                //  tileColor: Colors.black12,
                                leading: Text("${index + 1}"),
                                title: Text(
                                  "${paidItem(items)[index].name}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: Text(
                                  "${paidItem(items)[index].paid.price.toInt()} Kyats",
                                  style: TextStyle(
                                      color:
                                          paidItem(items)[index].paid.price < 0
                                              ? Colors.red
                                              : Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0.0, 0.0),
                                      color: Colors.black,
                                      blurRadius: .2)
                                ],
                              ),
                            ),
                            itemCount: paidItem(items).length,
                          ),
                        ),
                      ]),
                    );
                  },
                  minChildSize: .53,
                  initialChildSize: .53,
                  maxChildSize: 1,
                )
              ],
            )
          : Center(
              child: Text(
              "We do not have any payment yet!",
              style: TextStyle(fontSize: 20, color: Colors.red),
            )),
    );
  }

  double received(List<Item> items) {
    double totalReceived = 0;
    for (Item i in items) {
      if (calcTotal(i.gettingHelp) > calcTotal(i.needToHelpBack)) {
        if (i.paid != null) {
          totalReceived += i.paid.price;
        }
      }
    }
    return totalReceived;
  }

  int totalReceivedCount(List<Item> items) {
    int totalCount = 0;
    for (Item i in items) {
      if (calcTotal(i.gettingHelp) > calcTotal(i.needToHelpBack)) {
        if (i.paid != null) {
          totalCount += i.paid.count;
        }
      }
    }
    return totalCount;
  }

  List<Item> paidItem(List<Item> items) {
    List<Item> i = [];
    for (Item item in items) {
      if (item.isfinished) {
        i.add(item);
      }
    }
    return i;
  }

  double paid(List<Item> items) {
    double totalPaid = 0;
    for (Item i in items) {
      var nhb = calcTotal(i.needToHelpBack);
      var gh = calcTotal(i.gettingHelp);

      if (nhb > gh) {
        if (i.isfinished) {
          totalPaid += (nhb - gh) * (i.paid.price / i.paid.count);
        }
      }
    }
    return totalPaid;
  }

  int totalPaidCount(List<Item> items) {
    int totalcount = 0;
    for (Item i in items) {
      var nhb = calcTotal(i.needToHelpBack);
      var gh = calcTotal(i.gettingHelp);

      if (nhb > gh) {
        if (i.isfinished) {
          totalcount += (nhb - gh);
        }
      }
    }
    return totalcount;
  }

  int calcTotal(List<Help> lh) {
    int total = 0;
    if (lh == null || lh.length == 0) {
      return 0;
    }
    for (Help h in lh) {
      total += h.count;
    }
    return total;
  }
}
