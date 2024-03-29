//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hrecord/entities/expdata.dart';
import 'package:hrecord/fadepageroute.dart';
// import 'package:path_provider/path_provider.dart';
import './filteritembydate.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

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
    return Navigator.of(context).push(FadePageRoute(child: child));
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

  void exportPdf() async {
    box = await loadBox();
    final ttfFile = await rootBundle.load('fonts/Pyidaungsu-2.5_Regular.ttf');
    final pyiDsuFont = pw.Font.ttf(ttfFile);
    final dirpath = await FilePicker.platform.getDirectoryPath();
    print("$dirpath");
    final doc = pw.Document();
    final helplist = box.values.toList();
    helplist.sort((a, b) => a.name.compareTo(b.name));
    print(helplist.length);
    List<pw.TableRow> tableRows = [];
    for (int i = 0; i < helplist.length; i++) {
      if (i == 0) {
        tableRows.add(pw.TableRow(children: [
          pw.Text("ၶပ်ႉမၢႆ", style: pw.TextStyle(font: pyiDsuFont)),
          pw.Text("ၸိုဝ်ႈ", style: pw.TextStyle(font: pyiDsuFont)),
          pw.Text("ထႅမ်ၶဝ်", style: pw.TextStyle(font: pyiDsuFont)),
          pw.Text("ထႅမ်ႁဝ်း", style: pw.TextStyle(font: pyiDsuFont)),
        ]));
        // tableRows.add(pw.TableRow(children: [
        //   pw.Text("${i + 1}"),
        //   pw.Text(helplist[i].name, style: pw.TextStyle(font: pyiDsuFont)),
        //   pw.Text("${utils.totalHelpCount(helplist[i].gettingHelp)}"),
        //   pw.Text("${utils.totalHelpCount(helplist[i].needToHelpBack)}"),
        // ]));
      } else {
        if (helplist[i].name == "us") {
          tableRows.add(pw.TableRow(
            children: [
              pw.Text("$i"),
              pw.Text(helplist[i].name, style: pw.TextStyle(font: pyiDsuFont)),
              pw.Text("-"),
              pw.Text("${utils.totalHelpCount(helplist[i].needToHelpBack)}"),
            ],
          ));
        } else {
          tableRows.add(pw.TableRow(
            children: [
              pw.Text("$i"),
              pw.Text(helplist[i].name, style: pw.TextStyle(font: pyiDsuFont)),
              pw.Text("${utils.totalHelpCount(helplist[i].gettingHelp)}"),
              pw.Text("${utils.totalHelpCount(helplist[i].needToHelpBack)}"),
            ],
          ));
        }
      }
    }

    doc.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Header(
                child: pw.Text(r.name,
                    style: pw.TextStyle(
                      font: pyiDsuFont,
                      fontSize: 30,
                    ))),
            pw.Table(
              children: tableRows,
              columnWidths: const {
                0: pw.FixedColumnWidth(20),
                1: pw.FixedColumnWidth(50),
                2: pw.FixedColumnWidth(20),
                3: pw.FixedColumnWidth(20)
              },
              // children: box.values
              //     .toList()
              //     .map((e) => pw.TableRow(children: [
              //           // pw.Text(e.id,style: pw.TextStyle(font: padaukFont)),
              //           pw.Text(e.name, style: pw.TextStyle(font: pyiDsuFont)),
              //           pw.Text("${utils.totalHelpCount(e.gettingHelp)}"),
              //           pw.Text("${utils.totalHelpCount(e.needToHelpBack)}"),
              //         ]))
              //     .toList(),
            ),
            pw.Divider(),
            pw.Table(children: [
              pw.TableRow(children: [
                pw.Text("ႁဝ်းၵႃႇထႅမ် တင်းမူတ်းမူတ်း",style: pw.TextStyle(font: pyiDsuFont)),
                pw.Text("${utils.totalGettingHelp(helplist)}"),
              ]),
              pw.TableRow(children: [
                pw.Text("မႃးထႅမ်ႁဝ်း တင်းမူတ်းမူတ်း",style: pw.TextStyle(font: pyiDsuFont)),
                pw.Text("${utils.totalNeedToHelp(helplist)}"),
              ]),
            ]),
          ];
        },
      ),
    );

    // final path = await getExternalStorageDirectory();
    try {
      if (dirpath != null) {
        final pdfFile = dirpath + "/" + r.name + ".pdf";
        final pdf = File(pdfFile);
        showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
                  name: "သူင်ႇဢွၵ်ႇ",
                  content:pdfFile,
                )).then((value) async {
          if (value != null) {
            if (value) {
              print("$value");
              pdf.writeAsBytesSync(await doc.save());
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Data ${r.name}.pdf Successfully!")));
            }
          }
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void exportHrecordData() async {
    box = await loadBox();
    try {
      final dirpath = await FilePicker.platform.getDirectoryPath();
      final helplist = box.values.toList();
      try {
        if (dirpath != null) {
          final fileExport = dirpath + "/" + r.name + ".hrecord";
          final myh = File(fileExport);
          ExportData ed = ExportData(r, helplist);
          showDialog(
              context: context,
              builder: (context) => ConfirmDialog(
                    name: "သူင်ႇဢွၵ်ႇ",
                    content: fileExport,
                  )).then((value) async {
            if (value != null) {
              if (value) {
                myh.writeAsString(json.encode(ed));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Exported $fileExport successfully!")));
              }
            }
          });
        }
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
                            actions: [
                              PopupMenuButton<String>(
                                enabled:box.values.length > 1,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text(
                                      "သူင်ႇဢွၵ်ႇ PDF",
                                      style: TextStyle(fontFamily: "Padauk"),
                                    ),
                                    value: "pdf",
                                    
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      "သူင်ႇဢွၵ်ႇ hrecord",
                                      style: TextStyle(fontFamily: "Padauk"),
                                    ),
                                    value: "hfile",
                                  ),
                                ],
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                onSelected: (text) {
                                  if (text == "pdf") {
                                    exportPdf();
                                  } else if (text == "hfile") {
                                    exportHrecordData();
                                  }
                                },
                              ),
                            ],
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    title: "ႁဝ်းၵႃႇထႅမ်",
                                    totalCount: utils.totalGettingHelp(
                                        snap.data.values.toList()),
                                  ),
                                  TotalHelpShow(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: OpenContainer<String>(
                                    transitionDuration:
                                        Duration(milliseconds: 350),
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    closedColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    onClosed: (itemId) {
                                      if (itemId != null) {
                                        print(" delete item $itemId");
                                        if (itemId != null) {
                                          box.delete(itemId);
                                          setState(() {});
                                        } else {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    closedElevation: 0,
                                    closedBuilder: (context, closeContainer) {
                                      return ListTile(
                                        tileColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        contentPadding: EdgeInsets.all(6),
                                        dense: true,
                                        leading: Text("${index + 1}"),
                                        title: Text(
                                          item.name.length < 20
                                              ? item.name
                                              : item.name.substring(0, 20) +
                                                  "...",
                                          style: TextStyle(
                                              color: item.isfinished
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .color
                                                      .withOpacity(.5)
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .color,
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
                                                  count: utils.totalHelpCount(
                                                      item.gettingHelp),
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
                                      );
                                    },
                                    openBuilder: (context, openContainer) {
                                      return ItemDetail(
                                        price: r.price,
                                        recordId: r.id,
                                        itemId: item.id,
                                      );
                                    }));
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
                      color: Theme.of(context).primaryColor,
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
                                          name: "ၽႅတ်ႈ ${r.name}",
                                          content: "တေၽႅတ်ႈတေႉႁႃႉ?",
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
      title: Text(
        "လႅၵ်ႈလၢႆႈၵႃႈၶၼ်?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Padauk",
        ),
      ),
      content: TextField(
        controller: ctl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "ၵႃႈၶၼ်ယၢမ်းလဵဝ် $previousPrice kyats",
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color.withOpacity(.5),
            fontFamily: "Padauk",
          ),
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
                child: Text(
                  "ဢမ်ႇယဝ်ႉ",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Padauk",
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "တေႉယဝ်ႉ",
                    style: TextStyle(
                      fontFamily: "Padauk",
                    ),
                  ))
            ],
          ),
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
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0,
                    color: Theme.of(context).primaryColor)
              ],
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor)),
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
                        hintText: "တႅမ်ႈႁႃ",
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .headline6
                              .color
                              .withOpacity(.5),
                          fontFamily: "Padauk",
                        ),
                        border: InputBorder.none),
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
                      child: Text(
                        "မၢႆဢၼ်မႂ်ႇ",
                        style: TextStyle(
                          fontFamily: "Padauk",
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            datas.sort((a, b) => utils.sortByisDone(a, b));
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
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ListTile(
                dense: true,
                leading: Text("${index + 1}"),
                title: Text(
                  item.name.length < 20
                      ? item.name
                      : item.name.substring(0, 20) + "...",
                  style: TextStyle(
                      color: item.isfinished
                          ? Theme.of(context)
                              .textTheme
                              .headline6
                              .color
                              .withOpacity(.4)
                          : Theme.of(context).textTheme.headline6.color,
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
