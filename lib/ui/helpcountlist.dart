import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import '../entities/help.dart';
import '../utils/utils.dart' as utils;

class HelpCountList extends StatelessWidget {
  final bool isfinish;
  final Function callBackDelFunc;
  final List<Help> lh;
  HelpCountList({this.lh, this.callBackDelFunc, this.isfinish});
  Widget build(BuildContext ctx) {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder(
          itemCount: lh.length,
          indicatorBuilder: (context, index) => Indicator.outlined(
                child: Text(
                  "${index + 1}",
                  textAlign: TextAlign.center,
                ),
                size: 16,
                borderWidth: 1,
              ),
          startConnectorBuilder: (context, index) =>
              index == 0 ? null : Connector.solidLine(color: Colors.teal,),
          endConnectorBuilder: (context, index) =>
              index == lh.length - 1 ? null : Connector.solidLine(color: Colors.teal,),
          contentsBuilder: (context, index) {
            return Container(              
                child: ListTile(
                  // contentPadding: EdgeInsets.only(top:2,bottom:2),
                  title: Text(
                    "${lh[index].detail}",
                    style: TextStyle(fontSize: 12,),
                  ),
                  trailing: Text(
                    "${lh[index].count}",
                  ),
                  subtitle: Text(utils.fmtDate(lh[index].timeStamp)),
                  onTap: isfinish
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  title: Text(
                                    "ၽႅတ်ႈ ${lh[index].detail} ${lh[index].count}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content:
                                      Text("တေၽႅတ်ႈတေႉႁႃႉ?",textAlign: TextAlign.center,style: TextStyle(fontFamily:"Padauk",),),
                                  actions: [
                                   Container(
                                     width: MediaQuery.of(context).size.width,
                                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                                        TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text( "ဢမ်ႇ",style: TextStyle(fontFamily:"Padauk",),),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text("တေႉယဝ်ႉ",style: TextStyle(color: Colors.red,fontFamily:"Padauk",),))
                                     ],),
                                   )
                                  ],
                                );
                              }).then((value) {
                            if (value == true) {
                              //print("Deleted .. ${lh[index].id}");
                              callBackDelFunc(lh[index].id);
                            }
                            //callbackfunc
                          });
                        },
                ),
                margin: EdgeInsets.only(top: 1, bottom: 1));
          },
          nodePositionBuilder: (context, index) => .01),
    );
  }
}
