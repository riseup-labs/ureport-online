import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/number_format.dart';
import 'model/response_opinions.dart' as questionArray;
import 'statistics_age.dart';
import 'statistics_all.dart';
import 'statistics_gender.dart';
import 'statistics_location_spinner.dart';
import 'word_cloud.dart';

class OpinionItem extends StatefulWidget {
  questionArray.Question question;


  OpinionItem(this.question);

  @override
  _OpinionItemState createState() => _OpinionItemState(question);
}

class _OpinionItemState extends State<OpinionItem> {
  questionArray.Question question;

  int selectedTab = 0;



  _OpinionItemState(this.question);

  @override
  Widget build(BuildContext context) {

    print("Data is : ${question.id}");

    int set = question.results.resultsSet;
    int unset = question.results.unset;
    int total = set + unset;

    return Card(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Question
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                question.title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                "${FormattedNumber.formatNumber(set)} responded out of ${FormattedNumber.formatNumber(total)} polled",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[500], fontSize: 13),
              ),
            ),
            SizedBox(height: 9),
            //Tab
            question.resultsByGender.length != 0 ? Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Container(
                      width: 270,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedTab = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedTab == 0?Colors.black:Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                ),
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Center(child: Text("ALL",style: TextStyle(color: selectedTab == 0?Colors.white:Colors.black,fontSize: 13),)),
                              ) ,
                            ),
                          ),
                          Container(
                            height: 26,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedTab = 1;
                                });
                              },
                              child: Container(
                                color: selectedTab == 1?Colors.black:Colors.white,
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Center(child: Text("AGE",style: TextStyle(color: selectedTab == 1?Colors.white:Colors.black,fontSize: 13),)),
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedTab = 2;
                                });
                              },
                              child: Container(
                                color: selectedTab == 2?Colors.black:Colors.white,
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Center(child: Text("GENDER",style: TextStyle(color: selectedTab == 2?Colors.white:Colors.black,fontSize: 13),)),
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedTab = 3;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedTab == 3?Colors.black:Colors.white,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                                ),
                                padding: EdgeInsets.only(top: 5, bottom: 5, right: 7),
                                width: 70,
                                child: Center(child: Text("LOCATION",style: TextStyle(color: selectedTab == 3?Colors.white:Colors.black,fontSize: 13),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Divider
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(
                    height: 1.5,
                    color: Colors.grey[600],
                  ),
                ),
                //body
                Container(
                  child: getBody(question),
                ),
              ],
            ):question.results.categories.length>0?WordCloud.getWordCloud(context,question):Container(
              child: Text("Cloud is empty"),
            )
          ],
        ),
      ),
    );
  }

  getBody(questionArray.Question question){
    if(selectedTab == 0 && question.resultsByGender.length != 0){
      return StatisticsAll.getAllStatistics(question);
    }else if(selectedTab == 1&& question.resultsByLocation.length != 0){
      return StatisticsAge.getAgeStatistics(question);
    }else if(selectedTab == 2 && question.resultsByGender.length != 0){
      return StatisticsGender.getGenderStatistics(question);
    }else if(selectedTab == 3 && question.resultsByAge.length != 0){
      return StatisticsLocationSpinner(question);
    }
  }
}
