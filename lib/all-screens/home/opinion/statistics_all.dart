import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response_opinions.dart' as questionArray;

class StatisticsAll {

  static Widget getAllStatistics(questionArray.Question question,Color color) {
    int set  = question.results.resultsSet;
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: question.results.categories.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: LinearPercentIndicator(
                    animation: false,
                    lineHeight: 22.0,
                    backgroundColor: Colors.white,
                    percent: question.results.categories[index].count/set,
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text("${question.results.categories[index].label}",style: TextStyle(fontWeight: FontWeight.w700),)),
                      ],
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: color,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text("${(question.results.categories[index].count/set*100).round()}%"),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
