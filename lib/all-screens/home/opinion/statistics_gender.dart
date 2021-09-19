import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsGender {
  static List<MaterialColor> colors = [
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.amber,
    Colors.teal
  ];

  static Widget getGenderStatistics() {
    int colorNumber = 0;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 3, top: 10),
                child: Text("Male", style: TextStyle(fontWeight: FontWeight.w700),),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    if(colorNumber > colors.length-1){
                      colorNumber = 0;
                    }
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
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
                  }),
            ],
          );
        }
    );



  }
}
