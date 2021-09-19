import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsAll {
  static List<MaterialColor> colors = [
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.amber,
    Colors.teal
  ];

  static Widget getAllStatistics() {
    int colorNumber = 0;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          if(colorNumber > colors.length-1){
            colorNumber = 0;
          }
          return Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: LinearPercentIndicator(
                    animation: false,
                    lineHeight: 20.0,
                    backgroundColor: Colors.white,
                    percent: 0.8,
                    center: Text("80.0%"),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: colors[colorNumber++],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text("36%"),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
