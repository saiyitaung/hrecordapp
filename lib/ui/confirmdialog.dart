import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String name;
  final String content;
  ConfirmDialog({this.name, this.content});
  Widget build(BuildContext context) {
    return AlertDialog(
      
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        "$name",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent,fontFamily:"Padauk",),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily:"Padauk",),
      ),
      actions: [
        Container(child:TextButton(
          
            onPressed: () {
            //  print("cancel");
              Navigator.pop(context, false);
            },
            child: Text(
              "ဢမ်ႇ",
              style: TextStyle(color: Colors.red,fontFamily:"Padauk",),
            )),width: MediaQuery.of(context).size.width/3,),
            Container(width: MediaQuery.of(context).size.width/3,child:
        TextButton(
            
            onPressed: () {
             // print("Confirm");
              Navigator.pop(context, true);
            },
            child: Text(
              "တေႉယဝ်ႉ",
              style: TextStyle(color: Colors.green,fontFamily:"Padauk",),
            )),),
      ],
    );
  }
}
