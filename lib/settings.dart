import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hrecord/entities/help.dart';
import 'package:hrecord/entities/item.dart';
import 'package:hrecord/entities/record.dart';
import 'package:hrecord/mytheme/mytheme.dart';
import 'package:hrecord/ui/confirmdialog.dart';

class Settings extends StatefulWidget {
  final MyTheme myTheme;
  Settings(this.myTheme);
  _SettingState createState() => _SettingState(myTheme);
}

class _SettingState extends State<Settings> {
  var settings = Hive.box("settings");
  _SettingState(this.currentTheme);
  MyTheme currentTheme;
  TextEditingController regularHelpPrice = TextEditingController();
  TextEditingController sugarcanePearPrice = TextEditingController();
  TextEditingController defaultregulardetailCtl = TextEditingController();
  TextEditingController defaultsugarcanedetailCtl = TextEditingController();
  bool isDark;
  Widget build(BuildContext context) {
    isDark = settings.get("darkMode");
    sugarcanePearPrice.text = settings.get("sugarcaneprice") != null
        ? settings.get("sugarcaneprice")
        : "0";
    regularHelpPrice.text =
        settings.get("regularhelp") != null ? settings.get("regularhelp") : "0";
    defaultsugarcanedetailCtl.text = settings.get("sugarcanedetail") != null
        ? settings.get("sugarcanedetail")
        : "လွင်ႈတၢင်း";
    defaultregulardetailCtl.text = settings.get("regulardetail") != null
        ? settings.get("regulardetail")
        : "လွင်ႈတၢင်း";
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        leading: Icon(Icons.settings),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // TextField(controller: regularHelpPrice,keyboardType: TextInputType.number,maxLength: 3,onChanged: (c){print(c);},),
          // TextField(controller: sugarcanePearPrice,keyboardType: TextInputType.number,maxLength: 3,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: (MediaQuery.of(context).size.width / 100) * 60,
                  child: Text(
                    "Dark Mode",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Switch(
                      activeColor: Colors.teal,
                      value: isDark,
                      onChanged: (v) {
                        setState(() {
                          currentTheme.toggleTheme();
                          settings.put("darkMode", v);
                        });
                      }),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              "ၵႃႊၶၼ် တႃႇ လိတ်ႉဢွႆႈ",
              style:
                  TextStyle(fontFamily: "Padauk", fontWeight: FontWeight.bold),
            ),
            subtitle: ValueListenableBuilder(
              builder: (context, box, child) {
                return Text("${sugarcanePearPrice.text} kyats");
              },
              valueListenable: settings.listenable(),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditDefaultPrice(
                        t: sugarcanePearPrice,
                        title: "ၵႃႊၶၼ် တႃႇ လိတ်ႉဢွႆႈ",
                      )).then((value) {
                // print(sugarcanePearPrice.text);
                // if (settings.get("sugarcaneprice") != null) {
                //   settings.put("sugarcaneprice", sugarcanePearPrice.text);
                // } else {

                settings.put("sugarcaneprice", sugarcanePearPrice.text);

                //}
              });
            },
          ),
          ListTile(
            title: Text(
              "ၵႃႊၶၼ် တႃႇ ႁႅင်းဝၼ်း",
              style:
                  TextStyle(fontFamily: "Padauk", fontWeight: FontWeight.bold),
            ),
            subtitle: ValueListenableBuilder(
              builder: (context, box, child) {
                return Text("${regularHelpPrice.text} kyats");
              },
              valueListenable: settings.listenable(),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditDefaultPrice(
                        t: regularHelpPrice,
                        title: "ၵႃႊၶၼ် တႃႇ ႁႅင်းဝၼ် ",
                      )).then((value) {
                //print(regularHelpPrice.text);
                // if(settings.get("regularhelp") != null){
                // }
                settings.put("regularhelp", regularHelpPrice.text);
              });
            },
          ),
          ListTile(
            title: Text(
              "သႂ်ႇ လွင်ႈတၢင်း တႃႇ ႁႅင်းဝၼ်း",
              style:
                  TextStyle(fontFamily: "Padauk", fontWeight: FontWeight.bold),
            ),
            subtitle: ValueListenableBuilder(
              builder: (context, box, child) {
                return Text("${defaultregulardetailCtl.text}");
              },
              valueListenable: settings.listenable(),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditDefaultDetail(
                      title: "သႂ်ႇ လွင်ႈတၢင်း တႃႇ ႁႅင်းဝၼ်း",
                      t: defaultregulardetailCtl)).then((value) {
                if (value == true) {
                  settings.put("regulardetail", defaultregulardetailCtl.text);
                }
              });
            },
          ),
          ListTile(
            title: Text(
              "သႂ်ႇ လွင်ႈတၢင်း တႃႇ  လိတ်ႉဢွႆႈ",
              style:
                  TextStyle(fontFamily: "Padauk", fontWeight: FontWeight.bold),
            ),
            subtitle: ValueListenableBuilder(
              builder: (context, box, child) {
                return Text("${defaultsugarcanedetailCtl.text}");
              },
              valueListenable: settings.listenable(),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditDefaultDetail(
                      title: "သႂ်ႇ လွင်ႈတၢင်း တႃႇ လိတ်ႉဢွႆႈ",
                      t: defaultsugarcanedetailCtl)).then((value) {
                if (value == true) {
                  settings.put(
                      "sugarcanedetail", defaultsugarcanedetailCtl.text);
                }
              });
            },
          ),
          ListTile(
            title: Text("Import record from file"),
            onTap: () async {
              try {
                final pickedFile = await FilePicker.platform.pickFiles();
                if (pickedFile != null) {
                  PlatformFile pf = pickedFile.files.first;
                  if (pf.name.split(".")[1] == "hrecord") {
                    print(pf.name.split(".")[1]);
                    File f = File(pf.path);
                    var str = await f.readAsString();
                    var strdata = json.decode(str);
                    // print(strdata);

                    Record r = Record.fronJson(strdata['record']);
                    List<Item> items = [];
                    strdata['helps'].forEach((h) {
                      print(h);
                      Item i = Item.fronJson(h);
                      List<Help> nthb = [];
                      h['needToHelpBack'].forEach((lh) {
                        nthb.add(Help.fronJson(lh));
                      });
                      List<Help> gh = [];
                      h['gettingHelp'].forEach((lh) {
                        gh.add(Help.fronJson(lh));
                      });
                      i.needToHelpBack = nthb;
                      i.gettingHelp = gh;
                      items.add(i);
                    });
                    try {
                      showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog(
                                name: "Import File",
                                content: r.name,
                              )).then((value) async {
                        if (value != null) {
                          if (value) {
                            var mainBox = Hive.box<Record>("recordsBox");
                            if (!mainBox.containsKey(r.id)) {
                              mainBox.put(r.id, r);
                              await Hive.deleteBoxFromDisk(r.id);
                              var rbox = await Hive.openBox<Item>(r.id);
                              items.forEach((element) async {
                                await rbox.put(element.id, element);
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Import Data Sucess")));
                          }
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                    print("${r.name}");
                    print("${items.length}");
                    setState(() {});
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Make sure you import .hrecord file.")));
                }

                }
              } catch (e) {
                print(e.toString());

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Oop! Something was wrong!\n\n hrecord file that recorded hrecord version 1.7.0 later.")));
              }
            },
          )
        ]),
      ),
    );
  }
}

class EditDefaultPrice extends StatelessWidget {
  final String title;
  final TextEditingController t;
  EditDefaultPrice({this.title, this.t});
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.headline6.color,
            fontFamily: "Padauk",
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: t,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "ၵႃႈၶၼ်",
          labelStyle: TextStyle(
            fontFamily: "Padauk",
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  "ဢမ်ႇသႂ်ႇ",
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Padauk",
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "သႂ်ႇဝႆႉ",
                    style: TextStyle(
                        fontFamily: "Padauk", fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

class EditDefaultDetail extends StatelessWidget {
  final String title;
  final TextEditingController t;
  EditDefaultDetail({this.title, this.t});
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.headline6.color,
            fontFamily: "Padauk",
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        style: TextStyle(fontSize: 14),
        controller: t,
        decoration: InputDecoration(
          labelText: "လွင်ႈတၢင်း ",
          labelStyle: TextStyle(
            fontFamily: "Padauk",
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.name,
      ),
      actions: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      "ဢမ်ႇသႂ်ႇ",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Padauk",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        "သႂ်ႇဝႆႉ",
                        style: TextStyle(
                            fontFamily: "Padauk", fontWeight: FontWeight.bold),
                      )),
                ])),
      ],
    );
  }
}
