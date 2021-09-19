import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_age.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_all.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_gender.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/statistics_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response-opinion-localdb.dart';
import 'opinion_controller.dart';
import 'model/response_opinions.dart' as questionArray;

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
                      // NavUtils.push(context, StorySearch());
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
                          provider.getQuestionsFromLocal(opinions![0].title);
                          isLoaded = false;
                        }
                      }
                      return snapshot.hasData && provider.questionList.length>0?Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            headerStatistics(provider.questionList[0],opinions![0],provider),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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

  Widget headerStatistics(questionArray.Question question,ResultOpinionLocal opinions,OpinionController provider) {

    double guysResponseRate = 0.0;
    double maleResponseRate = 0.0;
    double femaleResponseRate = 0.0;
    int guysRespondent = 0;
    int maleRespondent = 0;
    int femaleRespondent = 0;

    String title = opinions.title.replaceAll("\n", " ");
    title = title.replaceAll("\r", " ");

    String category = opinions.category.toUpperCase();
    final dateTime = DateTime.parse(opinions.polldate);
    final format = DateFormat('dd MMMM, yyyy');
    final clockString = format.format(dateTime);

    int respondents = question.results.resultsSet;
    int totalRespondents = question.results.resultsSet+question.results.unset;
    double responseRate = (respondents/totalRespondents)*100;
    if(question.resultsByGender.length == 3){

      int guysSet = question.resultsByGender[2].resultsSet;
      int guysUnset = question.resultsByGender[2].unset;
      int femaleSet = question.resultsByGender[1].resultsSet;
      int femaleUnset = question.resultsByGender[1].unset;
      int maleSet = question.resultsByGender[0].resultsSet;
      int maleUnset = question.resultsByGender[0].unset;

      int gendeTotal = guysSet + femaleSet + maleSet;

      guysRespondent = guysSet;
      maleRespondent = maleSet;
      femaleRespondent = femaleSet;

      guysResponseRate = (guysSet/gendeTotal)*100;
      maleResponseRate = (maleSet/gendeTotal)*100;
      femaleResponseRate = (femaleSet/gendeTotal)*100;

    }else{
      int femaleSet = question.resultsByGender[1].resultsSet;
      int femaleUnset = question.resultsByGender[1].unset;
      int maleSet = question.resultsByGender[0].resultsSet;
      int maleUnset = question.resultsByGender[0].unset;

      maleRespondent = maleSet;
      femaleRespondent = femaleSet;

      maleResponseRate = (maleSet/maleUnset)*100;
      femaleResponseRate = (femaleSet/femaleUnset)*100;
    }


    return Column(
      children: [
        Container(
          child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
        ),
        SizedBox(height: 5,),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.all(5),
              child: Text(category, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),)
            ),
            SizedBox(width: 15,),
            Text(clockString, style: TextStyle(fontWeight: FontWeight.w700),)
          ],
        ),
        SizedBox(height: 8,),
        Container(
          child: Divider(
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 15,),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "${respondents.toString()}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RESPONDENTS",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "${responseRate.round().toString()}%",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RESPONSE RATE",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/male.png",
                          height: 26,
                          width: 26,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${question.resultsByGender[0].label}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${maleResponseRate.round().toString()}%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "${maleRespondent}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/female.png",
                          height: 26,
                          width: 26,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${question.resultsByGender[1].label}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${femaleResponseRate.round().toString()}%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "${femaleRespondent}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/gender_other.png",
                          height: 26,
                          width: 26,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${question.resultsByGender[2].label}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${guysResponseRate.round().toString()}%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "${guysRespondent}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
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
                child: getBody(),
              ),

          ],
        ),
      ),
    );
  }

  getBody(){
    if(selectedTab == 0){
      return StatisticsAll.getAllStatistics();
    }else if(selectedTab == 1){
      return StatisticsLocation.getLocationStatistics();
    }else if(selectedTab == 2){
      return StatisticsGender.getGenderStatistics();
    }else if(selectedTab == 3){
      return StatisticsAge.getAgeStatistics();
    }
  }
}


