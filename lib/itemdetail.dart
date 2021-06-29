import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './entities/pay.dart';
import './entities/record.dart';
import './ui/totalhelpcountshow.dart';

import 'package:uuid/uuid.dart';
import './entities/help.dart';
import './ui/chartdemo.dart';
import './ui/confirmdialog.dart';
import './entities/item.dart';
import './ui/helpcountlist.dart';
import './utils/utils.dart' as utils;
import './ui/helpdetail.dart';

class ItemDetail extends StatefulWidget {
  final String itemId;
  final String recordId;
  //final Item item;
  final int price;
  ItemDetail({this.price, this.itemId, this.recordId});
  _ItemDetailState createState() =>
      _ItemDetailState(price: price, recordId: recordId, itemId: itemId);
}

class _ItemDetailState extends State<ItemDetail> {
  Box<Item> itemsBox;
  String itemId;
  String recordId;
  //Item item;
  int price;
  _ItemDetailState({this.price, this.recordId, this.itemId});
  TextEditingController detailCtl = TextEditingController();
  TextEditingController countCtl = TextEditingController();

  TextEditingController ndetailCtl = TextEditingController();
  TextEditingController ncountCtl = TextEditingController();

  void initState() {
    super.initState();
    itemsBox = Hive.box(recordId);

    if (Hive.box<Record>("recordsBox").get(recordId).helpType ==
        "မႆၢႁႅင်းလိတ်ႉဢွႆႈ") {
      ndetailCtl.text = settings.get("sugarcanedetail") != null
          ? settings.get("sugarcanedetail")
          : "default";
    }else{
       ndetailCtl.text = settings.get("regulardetail") != null
          ? settings.get("regulardetail")
          : "default";
    }
  }

  var settings = Hive.box("settings");
  Widget build(BuildContext context) {
    //print(itemId);
    Item item = itemsBox.get(itemId);

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      //resizeToAvoidBottomInset: false,
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("${item.name}",style: TextStyle(fontSize: 16),),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: item.isfinished || item.name == "us"
                  ? null
                  : () {
                      print("Delete....");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmDialog(
                              name: "Delete ${item.name}",
                              content: "Are you sure?",
                            );
                          }).then((value) {
                        if (value == true) {
                          Navigator.pop(context, item.id);
                        }
                      });
                    }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            item.name == "us"
                ? Container(
                    child: HelpDetail(
                      title: "us",
                      callBackDetailController: ndetailCtl,
                      callBackCountController: ncountCtl,
                      callBackFunc: addMoreNeedToHelp,
                      isFinished: item.isfinished,
                      price: price,
                      wwidth: MediaQuery.of(context).size.width,
                      hheight: MediaQuery.of(context).size.height / 1.4,
                      color: Colors.redAccent,
                      helpCountList: HelpCountList(
                        isfinish: item.isfinished,
                        lh: item.needToHelpBack,
                        callBackDelFunc: delfromNeedToHelp,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HelpDetail(
                        title: "ႁဝ်းၵႃႇထႅမ်",
                        callBackDetailController: detailCtl,
                        callBackCountController: countCtl,
                        callBackFunc: addMoreGettingHelp,
                        isFinished: item.isfinished,
                        price: price,
                        color: Colors.lightGreen,
                        helpCountList: HelpCountList(
                          isfinish: item.isfinished,
                          lh: item.gettingHelp,
                          callBackDelFunc: delfromGettingHelp,
                        ),
                      ),
                      HelpDetail(
                        title: "မႃးထႅမ်ႁဝ်း",
                        callBackDetailController: ndetailCtl,
                        callBackCountController: ncountCtl,
                        callBackFunc: addMoreNeedToHelp,
                        isFinished: item.isfinished,
                        price: price,
                        color: Colors.redAccent,
                        helpCountList: HelpCountList(
                          isfinish: item.isfinished,
                          lh: item.needToHelpBack,
                          callBackDelFunc: delfromNeedToHelp,
                        ),
                      ),
                    ],
                  ),
            item.name == "us"
                ? Container(
                    child: TotalHelpShow(
                      title: "",
                      totalCount: utils.totalHelpCount(item.needToHelpBack),

                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              TotalHelpShow(
                                title: "",
                                totalCount:
                                    utils.totalHelpCount(item.gettingHelp),
                              ),
                              TotalHelpShow(
                                title: "",
                                totalCount:
                                    utils.totalHelpCount(item.needToHelpBack),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          // color: Colors.grey,
                          child: (item.gettingHelp.length == 0 &&
                                  item.needToHelpBack.length == 0)
                              ? Text("Empty")
                              : ChartDemo(
                                  item: item,
                                ),
                        ),
                        price != 0
                            ? utils.subHelpCount(item) == 0
                                ? Container()
                                : Padding(child:Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    // color: Colors.black12,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(
                                                  "ၼပ်ႉ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,                                                      
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Container(
                                                    child: Text(
                                                  "ၵႃႈၶၼ်",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Container(
                                                    child: Text(
                                                  "ၶၼ်ႁုပ်ႉတုမ်ႊ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(
                                                      
                                                  utils.subHelpCount(item) < 0
                                                      ? "${-utils.subHelpCount(item)}"
                                                      : "${utils.subHelpCount(item)}",
                                                      textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                                Container(
                                                  child: Text(
                                                    item.isfinished
                                                        ? "${item.paid.price / item.paid.count}"
                                                        : "$price",
                                                        textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                Container(
                                                    child: Text(
                                                  item.isfinished
                                                      ? "${item.paid.price}"
                                                      : utils.pay(
                                                                  item,
                                                                  price
                                                                      .toDouble()) <
                                                              0
                                                          ? "${-utils.pay(item, price.toDouble())}"
                                                          : "${utils.pay(item, price.toDouble())}",
                                                          textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),padding: EdgeInsets.symmetric(horizontal: 10),)
                            : Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: price <= 0
                                    ? Text(
                                        "You can't paid or received to finished this record if price is zero. You have to set default price first.",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : null,
                              ),
                        SizedBox(height: 10,),
                        TextButton(
                          onPressed: item.isfinished || price <= 0
                              ? null
                              : () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmDialog(
                                          name: "တေသွၼ်ႇတေႉႁိုဝ်?",
                                          content:
                                              "ပေႃးသွၼ်ႇယဝ်ႉလႅၵ်ႈလၢႆႊၶိုၼ်းဢမ်ႇလႆႈယဝ်ႉ",
                                        );
                                      }).then((value) {
                                    if (value) {
                                      setState(() {
                                        item.paid = Pay(
                                            count: utils.subHelpCount(item),
                                            price: utils
                                                .pay(item, price.toDouble())
                                                .toDouble());
                                        item.isfinished = true;
                                        //update db
                                        itemsBox.put(itemId, item);
                                      });
                                    }
                                  });
                                },
                          child: Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              utils.subHelpCount(item) == 0
                                  ? "ယဝ်ႉ"
                                  : utils.subHelpCount(item) < 0
                                      ? " ၸၢႆႇႁႂ်ႈယဝ်ႉ "
                                      : " received paymanent",
                            ),
                          ),
                          style: TextButton.styleFrom(
                            fixedSize: Size.fromWidth(200),
                            primary: utils.subHelpCount(item) == 0
                                ? Colors.blue
                                : utils.subHelpCount(item) < 0
                                    ? Colors.redAccent
                                    : Colors.green,
                            backgroundColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                         SizedBox(height: 10,),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void addMoreGettingHelp() {
    if ((detailCtl.text == null || detailCtl.text == "") ||
        (countCtl.text == null || countCtl.text == "")) {
      //print("incorrect input...");
    } else {
      var newHelp = Help(
          id: Uuid().v4(),
          detail: detailCtl.text,
          count: int.parse(countCtl.text),
          timeStamp: DateTime.now());
      setState(() {
        Item oldItem = itemsBox.get(itemId);
        oldItem.gettingHelp.add(newHelp);
        itemsBox.put(itemId, oldItem);
        //itemsBox.get(itemId).gettingHelp.add(newHelp);
        //  item.gettingHelp.add(newHelp);
        //detailCtl.clear();
        detailCtl.text = "Detail";
        countCtl.clear();
      });
    }
  }

  void addMoreNeedToHelp() {
    if ((ndetailCtl.text == null || ndetailCtl.text == "") ||
        (ncountCtl.text == null || ncountCtl.text == "")) {
      // print("incorrect input....");
    } else {
      var newHelp = Help(
          id: Uuid().v4(),
          detail: ndetailCtl.text,
          count: int.parse(ncountCtl.text),
          timeStamp: DateTime.now());
      setState(() {
        Item oldItem = itemsBox.get(itemId);
        oldItem.needToHelpBack.add(newHelp);
        itemsBox.put(itemId, oldItem);
        //itemsBox.get(itemId).needToHelpBack.add(newHelp);
        //item.needToHelpBack.add(newHelp);
        //ndetailCtl.clear();
        ndetailCtl.text = "Detail";
        ncountCtl.clear();
      });
    }
  }

  void delfromGettingHelp(String id) {
    for (Help h in itemsBox.get(itemId).gettingHelp) {
      if (h.id == id) {
        setState(() {
          //itemsBox.get(itemId).gettingHelp.remove(h);
          // remove help from old item
          Item oldItem = itemsBox.get(itemId);
          oldItem.gettingHelp.remove(h);

          //update
          itemsBox.put(itemId, oldItem);
        });
        return;
      }
    }
  }

  void delfromNeedToHelp(String id) {
    for (Help h in itemsBox.get(itemId).needToHelpBack) {
      if (h.id == id) {
        setState(() {
          Item oldItem = itemsBox.get(itemId);
          //itemsBox.get(itemId).needToHelpBack.remove(h);
          oldItem.needToHelpBack.remove(h);

          itemsBox.put(itemId, oldItem);
        });
        return;
      }
    }
  }
}
