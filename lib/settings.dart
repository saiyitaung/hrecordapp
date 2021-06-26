import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  var settings = Hive.box("settings");
  TextEditingController regularHelpPrice = TextEditingController();
  TextEditingController sugarcanePearPrice = TextEditingController();
  TextEditingController defaultregulardetailCtl = TextEditingController();
  TextEditingController defaultsugarcanedetailCtl = TextEditingController();
  Widget build(BuildContext context) {
    sugarcanePearPrice.text = settings.get("sugarcaneprice") != null
        ? settings.get("sugarcaneprice")
        : "0";
    regularHelpPrice.text =
        settings.get("regularhelp") != null ? settings.get("regularhelp") : "0";
    defaultsugarcanedetailCtl.text = settings.get("sugarcanedetail") != null
        ? settings.get("sugarcanedetail")
        : "detail";
    defaultregulardetailCtl.text = settings.get("regulardetail") != null
        ? settings.get("regulardetail")
        : "detail";
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        leading: Icon(Icons.settings),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // TextField(controller: regularHelpPrice,keyboardType: TextInputType.number,maxLength: 3,onChanged: (c){print(c);},),
          // TextField(controller: sugarcanePearPrice,keyboardType: TextInputType.number,maxLength: 3,),
          ListTile(
            title: Text("ၵႃႊၶၼ်လိတ်ႉဢွႆႈ default price "),
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
                        title: "ၵႃႊၶၼ်လိတ်ႉဢွႆႈ  \n default price ",
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
            title: Text("ၵႃႊၶၼ်ႁႅင်းဝၼ်း default price for half day"),
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
                        title: "ၵႃႊၶၼ်ႁႅင်းဝၼ်း default price for half day",
                      )).then((value) {
                    //print(regularHelpPrice.text);
                // if(settings.get("regularhelp") != null){

                // }
                settings.put("regularhelp", regularHelpPrice.text);
              });
            },
          ),
          ListTile(
            title: Text("Default text for ႁႅင်းဝၼ်း"),
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
                      title: "Default text for ႁႅင်းဝၼ်း",
                      t: defaultregulardetailCtl)).then((value) {
                if (value == true) {
                  settings.put("regulardetail", defaultregulardetailCtl.text);
                }
              });
            },
          ),
          ListTile(
            title: Text("Default text for လိတ်ႉဢွႆႈ"),
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
                      title: "Default text for လိတ်ႉဢွႆႈ",
                      t: defaultsugarcanedetailCtl)).then((value) {
                if (value == true) {
                  settings.put(
                      "sugarcanedetail", defaultsugarcanedetailCtl.text);
                }
              });
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
      title: Text(title),
      content: TextField(
        controller: t,
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Update")),
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
      title: Text(title),
      content: TextField(
        controller: t,
        keyboardType: TextInputType.name,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Update")),
      ],
    );
  }
}
