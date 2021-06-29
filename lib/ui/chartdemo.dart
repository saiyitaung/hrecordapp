import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../entities/item.dart';
import '../utils/utils.dart' as utils;

class ChartDemo extends StatelessWidget {
  final Item item;
  ChartDemo({this.item});
  Widget build(BuildContext ctx) {
    List<PieChartSectionData> listpie = [];
    listpie.add(
      PieChartSectionData(
        titleStyle: TextStyle(  color: Theme.of(ctx).textTheme.bodyText1.color,),
        value: utils.totalHelpCount(item.needToHelpBack).toDouble(),
        color: Colors.red.withOpacity(.6),
        title: utils.totalHelpCount(item.needToHelpBack) > 0
            ? "${utils.totalHelpCount(item.needToHelpBack)}"
            : "0",
        radius: 80,
      ),
    );
    listpie.add(
      PieChartSectionData(
        titleStyle: TextStyle(
          color: Theme.of(ctx).textTheme.bodyText1.color,
        ),
        value: utils.totalHelpCount(item.gettingHelp).toDouble(),
        color: Colors.green.withOpacity(.6),
        title: utils.totalHelpCount(item.gettingHelp) > 0
            ? "${utils.totalHelpCount(item.gettingHelp)} "
            : "0",
        radius: 80,
      ),
    );

    var piechart = PieChartData(
      startDegreeOffset: 270,
      sections: listpie,
      // centerSpaceRadius: 20,
      // centerSpaceColor: Colors.yellow,
      centerSpaceRadius: 0,
      borderData: FlBorderData(show: false),

    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row(
        //   children: [
        //     Container(
        //       width: MediaQuery.of(ctx).size.width / 2,
        //       color: Colors.green,
        //       height: 20,
        //     ),
        //     Text(
        //       "ႁဝ်းထႅမ်ၶဝ်",
        //     ),
        //   ],
        // ),
        // Row(
        //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Container(
        //       width: MediaQuery.of(ctx).size.width / 2,
        //       color: Colors.red,
        //       height: 20,
        //     ),
        //     Text("ၶဝ်ထႅမ်ႁဝ်း"),
        //   ],
        // ),
        Container(
          child: AspectRatio(
            child: PieChart(
              piechart,
              swapAnimationDuration: Duration(microseconds: 900),
              swapAnimationCurve: Curves.easeIn,
            ),
            aspectRatio: 1.99,
          
          ),
        ),
      ],
    );
  }
}
