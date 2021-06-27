

import 'package:flutter/material.dart';
import 'package:hrecord/scalepageroute.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import './filterrecord.dart';
import './settings.dart';
import './recorddetail.dart';
import './newrecord.dart';
import './entities/record.dart';
import './entities/record.g.dart';
import './entities/item.dart';
import './entities/item.g.dart';
import './entities/help.g.dart';
import './entities/pay.g.dart';

import './utils/utils.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final path = await getExternalStorageDirectory();
  // await Hive.initFlutter(path.path);
  // var pStats=await Permission.storage.request();
  // if (pStats.isDenied || pStats.isPermanentlyDenied){
  //   SystemNavigator.pop();
  // }
  //const String appDir="/storage/emulated/0/app.saiyi.hrecord";
  final appDir=await getExternalStorageDirectory();
  // var dir =Directory(appDir.path);
  print(appDir.path);
  await Hive.initFlutter(appDir.path);
  Hive.registerAdapter(RecordAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(HelpAdapter());
  Hive.registerAdapter(PayAdapter());
  await Hive.openBox<Record>("recordsBox");
  await Hive.openBox("settings");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'help records demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.teal,
        accentColor: Colors.teal[300],
        textTheme: Theme.of(context)
            .primaryTextTheme
            .apply(displayColor: Colors.black, bodyColor: Colors.black),
      ),
      home: MyHomePage(title: 'Records'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> sideMenu, slideContain;
  double width, height;
  Animation<double> scaleAni, fadeAni;
  Color white = Colors.white;

  Box<Record> rBox = Hive.box("recordsBox");

  void initState() {
    super.initState();

    // initialize animationController
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //setup sidemenu Offset tween
    sideMenu = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-300, 0.0))
        .animate(controller);
    //setup Container offset tween
    slideContain =
        Tween<Offset>(begin: Offset(250.0, 0.0), end: Offset(0.0, 0.0))
            .animate(controller);
    //scale ani
    scaleAni = Tween<double>(begin: 0.92, end: 1.0).animate(controller);

    // rotated=Tween<double>(begin: .3,end: 0).animate(controller);
    //setup fadeAni for button
    fadeAni = Tween(begin: 0.0, end: 1.0).animate(controller);

    //start animationController
    controller.forward();
  }

  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void animatedController() {
    if (controller.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }

  void addToNewRecord(Record newRecord) async {
    Item home = Item(
        id: Uuid().v4(),
        created: DateTime.now(),
        gettingHelp: [],
        needToHelpBack: [],
        isfinished: false,
        name: "us");
    Hive.openBox<Item>(newRecord.id).then((value) => value.put(home.id, home));
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.teal,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(
                offset: slideContain.value,
                child: Transform.scale(scale: scaleAni.value, child: child),
              );
            },
            child: Container(
              padding: EdgeInsets.only(top: 20),
              height: height,
              width: MediaQuery.of(context).size.width,
              // color: Colors.teal,
              child: ValueListenableBuilder(
                valueListenable: rBox.listenable(),
                builder: (context, Box<Record> box, widget) {
                  List<Record> records = box.values.toList();
                  records.sort((a, b) => utils.sortByDate(b, a));

                  return Container(
                    height: height,
                    width: width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          width: width,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  offset: Offset(0.0, 2),
                                  color: Colors.black,
                                  blurRadius: 3.0)
                            ],
                          ),
                          child: Row(
                            // mainAxisAlignment: Ma,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    animatedController();
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    size: 40,
                                  )),
                              Padding(
                                child: Text(
                                  "Records",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                padding: EdgeInsets.only(left: 30, top: 10),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  "${records[index].name}",
                                  style: TextStyle(fontSize: 24),
                                ),
                                onTap: () {
                                  route(RecordDetail(r: records[index]))
                                      .then((value) {
                                    if (value != null) {
                                      rBox.delete(value);
                                    }
                                  });
                                },
                                leading: Container(
                                  width: 45,
                                  height: 45,
                                  child: Image(
                                    fit: BoxFit.scaleDown,
                                    image: AssetImage("img/file.png"),
                                  ),
                                ),
                                // leading: Icon(
                                //   Icons.file_present,
                                //   size: 40,
                                //   color: Theme.of(context).primaryColor,
                                // ),
                                trailing: records[index].helpType ==
                                        "မႆၢႁႅင်းဝၼ်း"
                                    ? Text("ႁႅင်းဝၼ်း",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.teal.withOpacity(.5)))
                                    : Text("ႁႅင်းလိတ်ႉဢွႆႈ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.teal.withOpacity(.5))),
                                subtitle: Text(
                                  "${utils.fmtDate(records[index].timeStamp)}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                            itemCount: records.length,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.translate(offset: sideMenu.value, child: child);
            },
            child: Container(
              width: 250,
              height: height,
              padding: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(5.0, 0.0),
                    color: Colors.black,
                    blurRadius: 8.2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Card(
                    child: Container(
                      child: Image(
                        image: AssetImage("img/launchericon.png"),
                        height: 200,
                        fit: BoxFit.scaleDown,
                        width: 250,
                      ),
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: menuItemText("ႁႅင်းလိတ်ႉဢွႆႈ"),
                    leading: Icon(Icons.notes),
                    onTap: () {
                      animatedController();
                      filter("မႆၢႁႅင်းလိတ်ႉဢွႆႈ");
                    },
                  ),
                  ListTile(
                    title: menuItemText("ႁႅင်းဝၼ်း"),
                    leading: Icon(Icons.notes),
                    onTap: () {
                      animatedController();
                      filter("မႆၢႁႅင်းဝၼ်း");
                    },
                  ),
                  ListTile(
                    title: menuItemText("Setting"),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      route(Settings());
                      animatedController();
                    },
                  ),
                  ListTile(
                    title: menuItemText("About"),
                    leading: Icon(Icons.info),
                    onTap: () {
                      animatedController();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  "Help Record demo",
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Close"))
                                ],
                                content: Text(
                                  "version :  1.1.0  \n release in 2021 \n contact me  :  \ntwitter @saiyitaung ",
                                  textAlign: TextAlign.center,
                                ),
                              ));
                    },
                  ),
                ],
              ),
            ),
          ),
          // ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return FadeTransition(opacity: fadeAni, child: child);
        },
        child: Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionsBuilder: (context, ani, ani2, child) {
                    return Transform.scale(
                      alignment: Alignment.bottomCenter,
                      origin: const Offset(0.0, -30.0),
                      scale: ani.value,
                      child: child,
                    );
                    // return ScaleTransition(
                    //   scale: ani,
                    //   child: child,
                    //   alignment: Alignment.bottomCenter,
                    // );
                  }, pageBuilder: (context, ani, ani2) {
                    return NewRecord();
                  })).then((value) {
                if (value != null) {
                  setState(() {
                    // records.add(value);
                    rBox.put((value as Record).id, value);
                    addToNewRecord((value as Record));
                    // Fluttertoast.showToast(msg: "New Record Created.");
                  });
                  // print(value.id);
                }
                // print(records);
              });
            },
            child: Icon(Icons.add,color: Colors.white,),
          ),
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width / 2.7),
        ),
      ),
    );
  }

  Text menuItemText(String text) {
    return Text(
      text,
      style: TextStyle(color: white),
    );
  }

  Future<dynamic> route(Widget child) {
    return Navigator.of(context).push(ScalePageRoute(child: child));
  }

  void filter(String filter) {
    List<Record> filterRecord = [];
    rBox.values.toList().forEach((element) {
      if (element.helpType == filter) {
        filterRecord.add(element);
      }
    });
    route(
      FilterRecord(
        title: filter,
        records: filterRecord,
      ),
    );
  }
}
