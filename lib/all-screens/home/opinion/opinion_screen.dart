import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_search.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_age.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_all.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_gender.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_header.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/word_cloud.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response-opinion-localdb.dart';
import 'opinion_controller.dart';
import 'model/response_opinions.dart' as questionArray;
import 'statistics_location_spinner.dart';

class Opinion extends StatefulWidget {
  const Opinion({Key? key}) : super(key: key);

  @override
  _OpinionState createState() => _OpinionState();
}

class _OpinionState extends State<Opinion>{

  var isLoaded = true;

  @override
  Widget build(BuildContext context) {
    List<ResultOpinionLocal>? opinions = [];
    var sp = locator<SPUtil>();
    // Provider.of<OpinionController>(context, listen: false).getOpinionsFromRemote(
    //     RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
    //     sp.getValue(SPUtil.PROGRAMKEY));

    //done

    return Consumer<OpinionController>(builder: (context, provider, child) {
      return SafeArea(
          child: Scaffold(
              body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Image(
                    fit: BoxFit.fill,
                    height: 30,
                    width: 150,
                    image: AssetImage('assets/images/ureport_logo.png')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      "${AppLocalizations.of(context)!.opinions}",
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavUtils.push(context, OpinionSearch());
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.search,
                          size: 22,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Divider(
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<ResultOpinionLocal>>(
                    future: provider.getOpinionsFromLocal(sp.getValue(SPUtil.PROGRAMKEY)),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        opinions = snapshot.data;
                        if(isLoaded){
                          if(opinions!.isNotEmpty){
                            provider.getQuestionsFromLocal(opinions![0].title);
                            isLoaded = false;
                          }
                        }
                      }
                      return snapshot.hasData && provider.questionList.length>0?Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            StatisticsHeader.getHeadingStatistics(provider.questionList[0],opinions![0],provider),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: provider.questionList.length,
                                itemBuilder: (context, int index) {
                                  return getItem(provider.questionList[index],context, index);
                                })
                          ],
                        ),
                      ):Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      )));
    });
  }


  int selectedTab = 0;

  Widget getItem(questionArray.Question question,BuildContext context, int index) {

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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 7),
            //Tab
            question.resultsByGender.length != 0 ? Column(
              children: [
                Center(
                  child: Container(
                    width: 187,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
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
                            width: 35,
                            child: Center(child: Text("All",style: TextStyle(color: selectedTab == 0?Colors.white:Colors.black),)),
                          ) ,
                        ),
                        Container(
                          height: 28,
                          child: VerticalDivider(
                            width: 1.5,
                            thickness: 1,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Container(
                            color: selectedTab == 1?Colors.black:Colors.white,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            width: 55,
                            child: Center(child: Text("Location",style: TextStyle(color: selectedTab == 1?Colors.white:Colors.black),)),
                          ),
                        ),
                        Container(
                          height: 28,
                          child: VerticalDivider(
                            width: 1.5,
                            thickness: 1,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedTab = 2;
                            });
                          },
                          child: Container(
                            color: selectedTab == 2?Colors.black:Colors.white,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            width: 50,
                            child: Center(child: Text("Gender",style: TextStyle(color: selectedTab == 2?Colors.white:Colors.black),)),
                          ),
                        ),
                        Container(
                          height: 28,
                          child: VerticalDivider(
                            width: 1.5,
                            thickness: 1,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
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
                            width: 40,
                            child: Center(child: Text("Age",style: TextStyle(color: selectedTab == 3?Colors.white:Colors.black),)),
                          ),
                        ),
                      ],
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
            ):WordCloud.getWordCloud(context)

          ],
        ),
      ),
    );
  }

  getBody(questionArray.Question question){
    if(selectedTab == 0 && question.resultsByGender.length != 0){
      return StatisticsAll.getAllStatistics(question);
    }else if(selectedTab == 1&& question.resultsByLocation.length != 0){
      return StatisticsLocationSpinner(question);
    }else if(selectedTab == 2 && question.resultsByGender.length != 0){
      return StatisticsGender.getGenderStatistics(question);
    }else if(selectedTab == 3 && question.resultsByAge.length != 0){
      return StatisticsAge.getAgeStatistics(question);
    }
  }
}


