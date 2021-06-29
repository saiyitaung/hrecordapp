//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hrecord/scalepageroute.dart';
import './filteritembydate.dart';
// import 'package:hive_flutter/hive_flutter.dart';

import './ui/confirmdialog.dart';
import './itemdetail.dart';
import './newitem.dart';
import './entities/record.dart';
import './entities/item.dart';
import './totalpaidchart.dart';
import './utils/utils.dart' as utils;
import './ui/totalhelpcountshow.dart';
import './ui/showcountnum.dart';
// import './entities/help.dart';

class RecordDetail extends StatefulWidget {
  // this is for testing only before we get internet;
  final Record r;
  RecordDetail({this.r});
  _RecordDetailState createState() => _RecordDetailState(r: r);
}

class _RecordDetailState extends State<RecordDetail>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> slideDown;
  double currentPosition = 0.0;
  ScrollController scrollController;
//
  Record r;
  Box<Item> box;
  Box<Record> rBox = Hive.box("recordsBox");
  List<Item> searchData, displayData;
// <=
  _RecordDetailState({this.r});

  TextEditingController recordPriceCtl = TextEditingController();
  TextEditingController searchQuery = TextEditingController();
  Color green = Colors.lightGreen;
  Color red = Colors.redAccent;

  Future<Box<Item>> loadBox() async {
    if (Hive.isBoxOpen(r.id)) {
      return Hive.box(r.id);
    } else {
      return Hive.openBox<Item>(r.id);
    }
  }

  void initState() {
    super.initState();
    scrollController = ScrollController();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    slideDown = Tween(begin: Offset(0.0, 60.0), end: Offset(0.0, 0.0))
        .animate(controller);
    // slideToLeft = Tween(begin: Offset(0.0, 0.0), end: Offset(500.0, 0.0))
    //     .animate(controller2);
    // controller2.forward();
    controller.forward();
    scrollController.addListener(() {
      captureScroll();
    });
  }

  void captureScroll() {
    // print("demo");
    if (scrollController.position.pixels > currentPosition) {
      if (controller.isCompleted) {
        controller.reverse();
      }
      currentPosition = scrollController.position.pixels;
    } else {
      if (controller.isDismissed) {
        controller.forward();
      }
      currentPosition = scrollController.position.pixels;
    }
  }

  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<dynamic> route(Widget child) {
    return Navigator.of(context).push(ScalePageRoute(child: child));
  }

  List<Item> filterSearch(String q) {
    List<Item> filtered = [];
    searchData.forEach((element) {
      if (element.name.toLowerCase().contains(q.toLowerCase())) {
        filtered.add(element);
      }
    });
    return filtered;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned(
          top: 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: FutureBuilder(
                  future: loadBox(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      box = snap.data;
                      return CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            title: Text(
                              "${r.name}",
                              style: TextStyle(fontSize: 18),
                            ),
                            pinned: true,
                            expandedHeight: 130,
                            stretch: true,
                            flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                              padding: EdgeInsets.only(top: 50),
                              height: 60,
                              child: Row(
                                children: [
                                  TotalHelpShow(
                                    color: Theme.of(context).textTheme.headline1.color,
                                    title: "ႁဝ်းၵႃႇထႅမ်",
                                    totalCount: utils.totalGettingHelp(
                                        snap.data.values.toList()),
                                  ),
                                  TotalHelpShow(
                                    color: Theme.of(context).textTheme.headline1.color,                                    
                                    title: "မႃးထႅမ်ႁဝ်း",
                                    totalCount: utils.totalNeedToHelp(
                                        snap.data.values.toList()),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                            List<Item> items = box.values.toList();
                            items.sort((a, b) => utils.itemSortBytDate(b, a));
                            items.sort((a, b) => utils.sortByisDone(a, b));
                            Item item = items[index];
                            return Container(
                              height: 62,
                              decoration: BoxDecoration(
                              
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0.0, .1),
                                      color: Colors.black,
                                      blurRadius: .5)
                                ],
                                color:Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(6),
                                dense: true,
                                leading: Text("${index + 1}"),
                                title: Text(
                                  item.name.length < 15
                                      ? item.name
                                      : item.name.substring(0, 20) + "...",
                                  style: TextStyle(
                                      color: item.isfinished
                                          ? Theme.of(context).textTheme.bodyText1.color.withOpacity(.5)
                                          : Theme.of(context).textTheme.bodyText1.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      decoration: item.isfinished
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: Container(
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ShowCount(
                                          color: green,
                                          count: utils
                                              .totalHelpCount(item.gettingHelp),
                                          isfinished: item.isfinished),
                                      Text("|"),
                                      ShowCount(
                                        color: red,
                                        isfinished: item.isfinished,
                                        count: utils.totalHelpCount(
                                            item.needToHelpBack),
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  "${utils.fmtDate(item.created)}",
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemDetail(
                                              price: r.price,
                                              recordId: r.id,
                                              itemId: item.id,
                                            ))).then((value) {
                                  // Item foundItem = find(value, people);
                                  // closeSearchPageIfOpen();
                                  if (value != null) {
                                    box.delete(value);
                                    setState(() {});
                                  } else {
                                    setState(() {});
                                  }
                                }),
                              ),
                            );
                          }, childCount: box.values.length))
                        ],
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.teal,
                      ));
                    }
                  })),
        ),
        Positioned(
          bottom: 0,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                  offset: slideDown.value,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color:Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomIconBtn(
                          icon: Icons.add_box,
                          onPressed: () {
                            // closeSearchPageIfOpen();
                            route(NewItem(
                              record: r,
                            )).then((value) {
                              if (value != null) {
                                //setState(() {
                                box.put((value as Item).id, value);
                                //people.add(value);
                                //});
                                setState(() {});
                              }
                            });
                          },
                        ),
                        CustomIconBtn(
                          icon: Icons.search,
                          onPressed: () {
                            Navigator.of(context)
                                .push(PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 200),
                                    transitionsBuilder:
                                        (context, ani, ani2, child) {
                                      return FadeTransition(
                                          opacity: ani, child: child);
                                    },
                                    pageBuilder: (context, ani, ani2) {
                                      return CustomSearchHintDelegate(
                                          items: box.values.toList(),
                                          record: r);
                                    }))
                                .then((value) {
                              if (value != null) {
                                if (value == "createNew") {
                                 // print("need to create new ");
                                  route(NewItem(
                                    record: r,
                                  )).then((value) {
                                    if (value != null) {
                                      //setState(() {
                                      box.put((value as Item).id, value);
                                      //people.add(value);
                                      //});
                                      setState(() {});
                                    }
                                  });
                                } else {
                                  route(value).then((value) {
                                    if (value != null) {
                                      box.delete(value);
                                      setState(() {});
                                    } else {
                                      setState(() {});
                                    }
                                  });
                                }
                              }
                            });
                          },
                        ),
                        CustomIconBtn(
                          icon: Icons.monetization_on_outlined,
                          onPressed: () {
                            // closeSearchPageIfOpen();
                            showDialog(
                                context: context,
                                builder: (context) => EditRecordPrice(
                                      ctl: recordPriceCtl,
                                      previousPrice: r.price,
                                    )).then((value) {
                              if (value == true) {
                                r.price = int.parse(recordPriceCtl.text);
                                rBox.put(r.id, r);
                                setState(() {});
                              }
                              recordPriceCtl.clear();
                            });
                          },
                        ),
                        CustomIconBtn(
                          icon: Icons.bar_chart,
                          onPressed: () {
                            // route(PaidChart(
                            //   items: box.values.toList(),
                            //   price: r.price,
                            // ));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaidChart(
                                      items: box.values.toList(),
                                      price: r.price,
                                    )));
                          },
                        ),
                        CustomIconBtn(
                          icon: Icons.filter_alt_outlined,
                          onPressed: () {
                            List<Item> itemList = box.values.toList();

                            showDatePicker(                              
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: r.timeStamp,
                                    lastDate: DateTime.now())
                                .then((value) => {
                                      if (value != null)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FilterItemsByDate(
                                                          date: value,
                                                          items: utils
                                                              .filterByDate(
                                                                  itemList,
                                                                  value))))
                                        }
                                    });
                          },
                        ),
                        CustomIconBtn(
                          icon: Icons.delete,
                          onPressed: () {
                            showDialog(
                                    builder: (context) => ConfirmDialog(
                                          name: "Delete ${r.name}",
                                          content: "Are you sure?",
                                        ),
                                    context: context)
                                .then((value) {
                              if (value == true) {
                                Navigator.pop(context, r.id);
                                // print("Delete record..");
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ]),
    );
  }

  // void closeSearchPageIfOpen() {
  //   if (controller2.isDismissed) {
  //     controller2.forward();
  //   }
  // }
}

Item find(String id, List<Item> items) {
  for (Item i in items) {
    if (i.id == id) {
      return i;
    }
  }
  return null;
}

class EditRecordPrice extends StatelessWidget {
  final TextEditingController ctl;
  final int previousPrice;
  EditRecordPrice({this.ctl, this.previousPrice});
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text("Change price",textAlign: TextAlign.center,),
      content: TextField(
        controller: ctl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "current price is $previousPrice kyats",
          hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle1.color.withOpacity(.5)),
        ),
      ),
      actions: [
       Container(
         width: MediaQuery.of(context).size.width,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
            TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel",style: TextStyle(color: Colors.red),),),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Update"))
         ],),
       )
      ],
    );
  }
}

class CustomSearchHintDelegate extends StatefulWidget {
  final List<Item> items;
  final Record record;
  CustomSearchHintDelegate({this.items, this.record});
  _CustomSearchState createState() =>
      _CustomSearchState(record: record, items: items);
}

class _CustomSearchState extends State<CustomSearchHintDelegate> {
  List<Item> items;
  Record record;
  List<Item> datas;
  Color green = Colors.green;
  Color red = Colors.red;
  // Box<Item> box;
  _CustomSearchState({this.items, this.record});

  void initState() {
    super.initState();
    Hive.box<Item>(record.id);
    datas = items;
  }

  List<Item> filter(String query) {
    List<Item> filtered = [];
    items.forEach((i) {
      if (i.name.toLowerCase().contains(query.toLowerCase())) {
        filtered.add(i);
      }
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Search")),
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
         
          height: 60,
          decoration: BoxDecoration(
              color:Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0,
                    color: Theme.of(context).primaryColor)
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: Theme.of(context).primaryColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  
                  padding: EdgeInsets.only(top: 10, left: 10, right: 2),
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.teal,
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  
                  child: TextField(
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.teal, fontSize: 20),
                  
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Theme.of(context).textTheme.headline6.color.withOpacity(.5)),
                      border: InputBorder.none
                    ),
                    onChanged: (q) {
                      setState(() {
                        datas = filter(q);
                       
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        datas.length == 0
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    height: 60,
                    width: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.teal),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        // backgroundColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop("createNew");
                      },
                      child: Text("မၢႆဢၼ်မႂ်ႇ"),
                    ),
                  ),
                ),
              )
            : Container(),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
             datas.sort((a,b)=>utils.sortByisDone(a, b));
            Item item = datas[index];
            return Container(
              height: 62,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, .1),
                      color: Colors.black,
                      blurRadius: .5)
                ],
              color:Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ListTile(
                dense: true,
                leading: Text("${index + 1}"),
                title: Text(
                  item.name.length < 15
                      ? item.name
                      : item.name.substring(0, 20) + "...",
                  style: TextStyle(
                      color: item.isfinished
                          ? Theme.of(context).textTheme.headline6.color.withOpacity(.4)
                          :Theme.of(context).textTheme.headline6.color,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration:
                          item.isfinished ? TextDecoration.lineThrough : null),
                ),
                trailing: Container(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowCount(
                          color: green,
                          count: utils.totalHelpCount(item.gettingHelp),
                          isfinished: item.isfinished),
                      Text("|"),
                      ShowCount(
                        color: red,
                        isfinished: item.isfinished,
                        count: utils.totalHelpCount(item.needToHelpBack),
                      )
                    ],
                  ),
                ),
                subtitle: Text(
                  "${utils.fmtDate(item.created)}",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  //  print(record.id);
                  Navigator.pop(
                      context,
                      ItemDetail(
                        price: record.price,
                        recordId: record.id,
                        itemId: item.id,
                      ));
                },
              ),
            );
          },
          itemCount: datas.length,
        )),
      ]),
    );
  }
}

class CustomIconBtn extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  CustomIconBtn({@required this.icon, @required this.onPressed});
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
