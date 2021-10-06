import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/number_format.dart';
import 'model/response_opinions.dart' as questionArray;
import 'statistics_age.dart';
import 'statistics_all.dart';
import 'statistics_gender.dart';
import 'statistics_location_spinner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'word_cloud.dart';

class OpinionItem extends StatefulWidget {

  questionArray.Question question;
  Color color;

  OpinionItem(this.question, this.color);

  @override
  _OpinionItemState createState() => _OpinionItemState(question, color);
}

class _OpinionItemState extends State<OpinionItem> {
  questionArray.Question question;
  Color color;

  int selectedTab = 0;



  _OpinionItemState(this.question, this.color);

  @override
  Widget build(BuildContext context) {

    int set = question.results.resultsSet;
    int unset = question.results.unset;
    int total = set + unset;

    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
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
                  "${FormattedNumber.formatNumber(set)} ${AppLocalizations.of(context)!.responded_out_of} ${FormattedNumber.formatNumber(total)} ${AppLocalizations.of(context)!.polled}",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: GestureDetector(
                                onTap: (){
                                  ClickSound.soundTap();
                                  setState(() {
                                    selectedTab = 0;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedTab == 0?Colors.grey[700]:Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Center(child: Text(AppLocalizations.of(context)!.all,style: TextStyle(color: selectedTab == 0?Colors.white:Colors.black,fontSize: 11),)),
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
                                  ClickSound.soundTap();
                                  setState(() {
                                    selectedTab = 1;
                                  });
                                },
                                child: Container(
                                  color: selectedTab == 1?Colors.grey[700]:Colors.white,
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Center(child: Text(AppLocalizations.of(context)!.age,style: TextStyle(color: selectedTab == 1?Colors.white:Colors.black,fontSize: 11),)),
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
                                  ClickSound.soundTap();
                                  setState(() {
                                    selectedTab = 2;
                                  });
                                },
                                child: Container(
                                  color: selectedTab == 2?Colors.grey[700]:Colors.white,
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Center(child: Text(AppLocalizations.of(context)!.gender,style: TextStyle(color: selectedTab == 2?Colors.white:Colors.black,fontSize: 11),)),
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
                                  ClickSound.soundTap();
                                  setState(() {
                                    selectedTab = 3;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedTab == 3?Colors.grey[700]:Colors.white,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 7),
                                  child: Center(child: Text(AppLocalizations.of(context)!.location,style: TextStyle(color: selectedTab == 3?Colors.white:Colors.black,fontSize: 11),)),
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
                    child: getBody(question,color),
                  ),
                ],
              ):question.results.categories.length>0?WordCloud.getWordCloud(context,question):Container()
            ],
          ),
        ),
      ),
    );
  }

  getBody(questionArray.Question question,Color color){
    if(selectedTab == 0 && question.resultsByGender.length != 0){
      return StatisticsAll.getAllStatistics(question,color);
    }else if(selectedTab == 1&& question.resultsByLocation.length != 0){
      return StatisticsAge.getAgeStatistics(question,color);
    }else if(selectedTab == 2 && question.resultsByGender.length != 0){
      return StatisticsGender.getGenderStatistics(question,color);
    }else if(selectedTab == 3 && question.resultsByAge.length != 0){
      return StatisticsLocationSpinner(question,color);
    }
  }
}
