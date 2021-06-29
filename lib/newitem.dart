import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './entities/help.dart';
import 'package:uuid/uuid.dart';
import './entities/item.dart';
import './entities/record.dart';

class NewItem extends StatefulWidget {
  final Record record;
  NewItem({this.record});
  _NewItemState createState() => _NewItemState(record: record);
}

class _NewItemState extends State<NewItem> {
  Record record;
  _NewItemState({this.record});
  var settings = Hive.box("settings");
  bool itemExist = false;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController detailCtl = TextEditingController();
  TextEditingController countCtl = TextEditingController();
  var choice = ["မႃးထႅမ်ႁဝ်း", "ႁဝ်းၵႃႇထႅမ်"];
  String selecteditem = "မႃးထႅမ်ႁဝ်း";
  Widget build(BuildContext context) {
    Box<Item> items = Hive.box(record.id);
    //detailCtl.text="blah blah";
    if (record.helpType == "မႆၢႁႅင်းဝၼ်း") {
      detailCtl.text = settings.get("regulardetail") != null
          ? settings.get("regulardetail")
          : "default";
    } else {
      detailCtl.text = settings.get("sugarcanedetail") != null
          ? settings.get("sugarcanedetail")
          : "default";
    }
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("မၢႆဢၼ်မႂ်ႇ"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            TextField(
              controller: nameCtl,
              style: TextStyle(fontSize: 16),
              //focusNode: FocusScope.of(context),
              decoration: InputDecoration(
                  hintText: "ၸိုဝ်ႈ",
                  labelText:  "ၸိုဝ်ႈ",
                  hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle1.color.withOpacity(.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Radio(
                            value: "မႃးထႅမ်ႁဝ်း",
                            groupValue: selecteditem,
                            onChanged: (v) {
                              setState(() {
                                selecteditem = v;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                            ),
                        Text(
                          "မႃးထႅမ်ႁဝ်း",
                          style: TextStyle(
                              color: selecteditem == "မႃးထႅမ်ႁဝ်း"
                                  ? Colors.teal
                                  : null),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Radio(
                           fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                            value: "ႁဝ်းၵႃႇထႅမ်",
                            groupValue: selecteditem,
                            onChanged: (v) {
                              setState(() {
                                selecteditem = v;
                              });
                            }),
                        Text(
                          "ႁဝ်းၵႃႇထႅမ်",
                          style: TextStyle(
                              color: selecteditem == "ႁဝ်းၵႃႇထႅမ်"
                                  ? Colors.teal
                                  : null),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // child: Padding(
              //   padding: EdgeInsets.only(left: 10, right: 10),

              // child: DropdownButton<String>(
              //   dropdownColor: Colors.teal,
              //   style: TextStyle(color: Colors.white, fontSize: 18),
              //   isExpanded: true,
              //   iconSize: 30,
              //   iconEnabledColor: Colors.white,
              //   items: choice
              //       .map(
              //         (e) => DropdownMenuItem<String>(
              //           child: Text(
              //             e,
              //             textAlign: TextAlign.center,
              //           ),
              //           onTap: () {
              //             setState(() {
              //               selecteditem = e;
              //             });
              //           },
              //           value: e,
              //         ),
              //       )
              //       .toList(),
              //   onChanged: (d) {
              //     //print(selecteditem);
              //   },
              //   selectedItemBuilder: (context) => choice
              //       .map(
              //         (e) => Container(
              //           child: Text(
              //             e,
              //           ),
              //           padding: EdgeInsets.only(left: 10),
              //         ),
              //       )
              //       .toList(),
              //   value: selecteditem,
              // ),
            ),
            TextField(
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                  hintText: "လွင်ႈ/ဢွင်ႈတီႈ",
                  labelText: "လွင်ႈ/ဢွင်ႈတီႈ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              controller: detailCtl,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "1",                  
                   hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle1.color.withOpacity(.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              keyboardType: TextInputType.number,
              controller: countCtl,
              maxLength: record.helpType == "မႆၢႁႅင်းဝၼ်း" ? 1 : 3,
            ),
            TextButton(
              onPressed: () {
                if ((nameCtl.text == null || nameCtl.text == "") ||
                    (detailCtl.text == null || detailCtl.text == "") ||
                    (countCtl.text == null || countCtl.text == "")) {
                  //print("incorrect input");
                } else {
                  Item newItem = Item(
                      id: Uuid().v4(),
                      name: nameCtl.text,
                      created: DateTime.now());
                  // initialize list
                  // print(nameCtl.text);
                  newItem.gettingHelp = [];
                  newItem.needToHelpBack = [];
                  //
                  List<Help> lh = [
                    Help(
                        id: Uuid().v4(),
                        detail: detailCtl.text,
                        count: int.parse(countCtl.text),
                        timeStamp: DateTime.now())
                  ];
                  if (selecteditem == "ႁဝ်းၵႃႇထႅမ်") {
                    newItem.gettingHelp = lh;
                  } else {
                    newItem.needToHelpBack = lh;
                  }
                  items.values.forEach((element) {
                    if (element.name == newItem.name) {
                      itemExist = true;
                    }
                  });
                  if (itemExist) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                              title: Text(
                                "We already have one :-)",
                                textAlign: TextAlign.center,
                              ),
                            )).then((value) {
                      setState(() {
                        nameCtl.clear();
                        //countCtl.clear();

                        newItem = null;
                        itemExist = false;
                      });
                    });
                  } else {
                    Navigator.pop(context, newItem);
                  }
                }
              },
              child: Container(
                child: Text(
                  "မၢႆသႂ်ႇ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                width: double.infinity,
                // padding: EdgeInsets.only(top: 3, bottom: 3),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
            ),
          ],
        ),
      ),
    );
  }
}
