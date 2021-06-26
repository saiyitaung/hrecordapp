import 'package:flutter/material.dart';
import './helpcountlist.dart';

class HelpDetail extends StatelessWidget {
  final TextEditingController callBackDetailController;
  final TextEditingController callBackCountController;
  final int price;
  final bool isFinished;
  final Function callBackFunc;
  final HelpCountList helpCountList;
  final String title;
  final Color color;
  final double wwidth;
  final double hheight;
  HelpDetail(
      {this.title,
      this.color,
      this.callBackDetailController,
      this.callBackCountController,
      this.price,
      this.isFinished,
      this.callBackFunc,
      this.helpCountList,
      this.wwidth,
      this.hheight});
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], boxShadow: [
        BoxShadow(
            offset: Offset(0.0, 0.0), color: Colors.black87, blurRadius: .2)
      ]),
      height: hheight == null ? 300 : hheight,
      width: wwidth == null ? MediaQuery.of(context).size.width / 2 : wwidth,
      child: Column(children: [
        !isFinished ?Container(
          child: ExpansionTile(           
            title: Text(
              "add More",
            ),
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: "Detail",
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                controller: callBackDetailController,
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: callBackCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "1", contentPadding: EdgeInsets.only(left: 10)),
                maxLength: price > 1000 ? 1 : 3,
              ),
              Container(
                child: TextButton(
                  onPressed: isFinished ? null : callBackFunc,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50)),
                  ),
                  child: Text(
                    "Add ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
          color: Colors.white,
          margin: EdgeInsets.only(left: 2, right: 2),
        ):Container(height: 10,),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Expanded(
          child: helpCountList,
        ),
      ]),
    );
  }
}
