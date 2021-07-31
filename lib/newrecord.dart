import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './entities/record.dart';
import 'package:uuid/uuid.dart';

class NewRecord extends StatefulWidget {
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  var settingsBox = Hive.box("settings");
  List<String> helpTypes = ["မႆၢႁႅင်းဝၼ်း", "မႆၢႁႅင်းလိတ်ႉဢွႆႈ"];
  String selectedItem = "မႆၢႁႅင်းဝၼ်း";
  String himg = "img/nh.png";
  TextEditingController _textCtl = TextEditingController();
  Widget build(BuildContext context) {
    // var n = "new Record";
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("တၢင်ႇၽိုၼ်မႂ်ႇ",style: TextStyle(fontFamily:"Padauk",),),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                //  color: Colors.grey,
                border: Border.all(
                    width: 2, color: Colors.teal, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(100),
              ),
              width: 100,
              height: 100,
              child: Image(
                image: AssetImage(himg),
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              // color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Radio(
                           fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                            value: "မႆၢႁႅင်းဝၼ်း",
                            groupValue: selectedItem,
                            onChanged: (v) {
                              setState(() {
                                selectedItem = v;
                                himg = "img/nh.png";
                              });
                            }),
                        Text("မႆၢႁႅင်းဝၼ်း",style: TextStyle(color: selectedItem=="မႆၢႁႅင်းဝၼ်း"?Colors.teal:null,fontFamily:"Padauk",),),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Radio(
                           fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                            value: "မႆၢႁႅင်းလိတ်ႉဢွႆႈ",
                            groupValue: selectedItem,
                            onChanged: (v) {
                              setState(() {
                                selectedItem = v;
                                himg = "img/sgc.png";
                              });
                            }),
                        Text("မႆၢႁႅင်းလိတ်ႉဢွႆႈ",style: TextStyle(color: selectedItem=="မႆၢႁႅင်းလိတ်ႉဢွႆႈ"?Colors.teal:null,fontFamily:"Padauk",),)
                      ],
                    ),
                  )
                ],

                // child: DropdownButton(
                //   dropdownColor: Colors.teal,
                //   iconEnabledColor: Colors.white,
                //   iconSize: 30,
                //   isExpanded: true,
                //   style: TextStyle(color: Colors.white, fontSize: 18,),
                //   items: helpTypes
                //       .map(
                //         (e) => DropdownMenuItem(
                //           child: Text(
                //             e,
                //           ),
                //           onTap: () {
                //             setState(() {
                //               selectedItem = e;
                //               if (e == "မႆၢႁႅင်းဝၼ်း") {
                //                 himg = "img/nh.png";
                //               } else {
                //                 himg = "img/sgc.png";
                //               }
                //             });
                //           },
                //           value: e,
                //         ),
                //       )
                //       .toList(),
                //   onChanged: (s) {
                //     setState(() {
                //       selectedItem = s;
                //     });
                //   },
                //   selectedItemBuilder: (context) {
                //     return helpTypes
                //         .map((e) => Container(
                //               child: Text(
                //                 e,
                //               ),
                //               padding:
                //                   EdgeInsets.only(left: 20, top: 5, bottom: 5),
                //             ))
                //         .toList();
                //   },
                //   value: selectedItem,
                // ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  hintText: "သႂ်ပၼ်ၸိုဝ်ႈ",
                  labelText: "သႂ်ပၼ်ၸိုဝ်ႈ",
                  labelStyle:TextStyle(fontFamily:"Padauk",),
                   hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle1.color.withOpacity(.5),fontFamily:"Padauk",),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: _textCtl,
            ),
            SizedBox(height: 10),
            TextButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                // print(_textCtl.text);
                if (_textCtl.text != "" && _textCtl.text != null) {
                  // print(_textCtl.text);
                  var newRecord = Record(
                      id: Uuid().v4(),
                      name: _textCtl.text,
                      timeStamp: DateTime.now(),
                      helpType: selectedItem);
                  // print(newRecord.helpType);
                  if (newRecord.helpType == "မႆၢႁႅင်းဝၼ်း") {
                    newRecord.price = settingsBox.get("regularhelp") != null
                        ? int.parse(settingsBox.get("regularhelp"))
                        : 0;
                  } else {
                    newRecord.price = settingsBox.get("sugarcaneprice") != null
                        ? int.parse(settingsBox.get("sugarcaneprice"))
                        : 0;
                  }
                  Navigator.pop(context, newRecord);
                }
              },
              child: Container(
                child: Text(
                  "ႁဵတ်းဢၼ်မႂ်ႇ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white,fontFamily:"Padauk",),
                ),
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.only(top: 3, bottom: 3),
              ),
              // color: Theme.of(context).primaryColor,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
            )
          ],
        ),
      ),
    );
  }
}
