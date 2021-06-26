import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String name;
  final String content;
  ConfirmDialog({this.name, this.content});
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "$name",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        Container(child:TextButton(
          
            onPressed: () {
            //  print("cancel");
              Navigator.pop(context, false);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            )),width: MediaQuery.of(context).size.width/3,),
            Container(width: MediaQuery.of(context).size.width/3,child:
        TextButton(
            
            onPressed: () {
             // print("Confirm");
              Navigator.pop(context, true);
            },
            child: Text(
              "Comfirm",
              style: TextStyle(color: Colors.green),
            )),),
      ],
    );
  }
}
