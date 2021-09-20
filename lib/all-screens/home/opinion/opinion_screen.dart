import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response-opinion-localdb.dart';
import 'opinion_controller.dart';
import 'model/response_opinions.dart' as questionArray;
import 'opinion_item.dart';
import 'statistics_header.dart';

class Opinion extends StatefulWidget {
  const Opinion({Key? key}) : super(key: key);

  @override
  _OpinionState createState() => _OpinionState();
}
var count = 0;

class _OpinionState extends State<Opinion> {
  var isLoaded = true;
  // List<questionArray.Question> questionList = [];

  var sp = locator<SPUtil>();

  @override
  Widget build(BuildContext context) {
    List<ResultOpinionLocal>? opinions = [];

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
                      future: provider.getOpinionsFromLocal(sp.getValue(SPUtil.PROGRAMKEY), provider.opinionID),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          opinions = snapshot.data;
                          if(opinions!.length > 0){
                            var mapdata = jsonDecode(opinions![0].questions);
                            // questionList.clear();
                            List<questionArray.Question> questionList = (mapdata as List)
                                .map((e) => questionArray.Question.fromJson(e))
                                .toList();
                            return snapshot.hasData
                                ? Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  questionList.length > 0
                                      ? StatisticsHeader
                                      .getHeadingStatistics(
                                      questionList[0],
                                      opinions![0],
                                      provider)
                                      : StatisticsHeader
                                      .getHeadingStatisticsEmpty(
                                      opinions![0]),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: questionList.length,
                                      itemBuilder: (context, int index) {
                                        return OpinionItem(questionList[index]);
                                      })
                                ],
                              ),
                            )
                                : Container(
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      )));
    });
  }

}
