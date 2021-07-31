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
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 0.0), color: Colors.black87, blurRadius: .2)
          ]),
      height: hheight == null ? (MediaQuery.of(context).size.height /100) * 50 : hheight,
      width: wwidth == null ? MediaQuery.of(context).size.width / 2 : wwidth,
      child: Column(children: [
        !isFinished
            ? Container(
                child: ExpansionTile(
                  textColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  collapsedIconColor: Theme.of(context).textTheme.headline6.color,
                  title: Text(
                    "ထႅမ်သႂ်ႇထႅင်ႈ",
                    style: TextStyle(fontFamily:"Padauk",),
                  ),
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      
                      showCursor: true,
                      decoration: InputDecoration(
                        hintText: "လွင်ႈတၢင်း/ဢွင်ႈ/ၸိုဝ်ႈ",                      
                        hintStyle: TextStyle(fontSize: 12,color: Theme.of(context).textTheme.headline6.color.withOpacity(.4),fontFamily:"Padauk",),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      controller: callBackDetailController,
                      style: TextStyle(fontSize: 13),
                    ),
                    TextFormField(
                      controller: callBackCountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "1",
                          hintStyle: TextStyle(color:  Theme.of(context).textTheme.headline6.color.withOpacity(.4)),
                          contentPadding: EdgeInsets.only(left: 10)),
                      maxLength: price > 1000 ? 1 : 3,
                    ),
                    Container(
                      child: TextButton(
                        onPressed: isFinished ? null : callBackFunc,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: Text(
                          "ထႅမ်သႂ်ႇ",
                          style: TextStyle(color: Colors.white,fontFamily:"Padauk",),
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
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                margin: EdgeInsets.only(left: 2, right: 2),
              )
            : Container(
                height: 10,
              ),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily:"Padauk",
          ),
        ),
        Expanded(
          child: helpCountList,
        ),
      ]),
    );
  }
}
