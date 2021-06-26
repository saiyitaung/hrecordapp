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
        title: Text("New Record"),
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
              width: 150,
              height: 150,
              child: Image(
                image: AssetImage(himg),
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButton(
                  dropdownColor: Colors.teal,
                  iconEnabledColor: Colors.white,
                  iconSize: 30,
                  isExpanded: true,
                  style: TextStyle(color: Colors.white, fontSize: 18,),
                  items: helpTypes
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(
                            e,
                          ),
                          onTap: () {
                            setState(() {
                              selectedItem = e;
                              if (e == "မႆၢႁႅင်းဝၼ်း") {
                                himg = "img/nh.png";
                              } else {
                                himg = "img/sgc.png";
                              }
                            });
                          },
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (s) {
                    setState(() {
                      selectedItem = s;
                    });
                  },
                  selectedItemBuilder: (context) {
                    return helpTypes
                        .map((e) => Container(
                              child: Text(
                                e,
                              ),
                              padding:
                                  EdgeInsets.only(left: 20, top: 5, bottom: 5),
                            ))
                        .toList();
                  },
                  value: selectedItem,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  hintText: "Record Name",
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
                  "Create",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.only(top: 10, bottom: 10),
              ),
              // color: Theme.of(context).primaryColor,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.teal),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
            )
          ],
        ),
      ),
    );
  }
}