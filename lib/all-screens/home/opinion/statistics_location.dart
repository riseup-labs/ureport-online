import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'model/response_opinions.dart' as questionArray;

class StatisticsLocation {
  static List<MaterialColor> colors = [
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.amber,
    Colors.teal
  ];

  static Widget getLocationStatistics(questionArray.Question question) {
    int colorNumber = 0;

    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: question.resultsByLocation.length,
        itemBuilder: (context, index1){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 3, top: 10),
                child: Text("${question.resultsByLocation[index1].label}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: question.resultsByLocation[index1].categories.length,
                  itemBuilder: (context, index) {
                    if(colorNumber > colors.length-1){
                      colorNumber = 0;
                    }
                    int set  = question.resultsByLocation[index1].resultsByLocationSet;
                    int count  = question.resultsByLocation[index1].categories[index].count;
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            child: LinearPercentIndicator(
                              animation: false,
                              lineHeight: 20.0,
                              backgroundColor: Colors.white,
                              percent: set !=0?count/set:0.0,
                              center: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Text("${question.resultsByLocation[index1].categories[index].label}",style: TextStyle(fontWeight: FontWeight.w700))),
                                ],
                              ),
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
                              child: Text("${((set !=0?count/set:0.0)*100).round()}%"),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          );
        }
    );



  }
}
