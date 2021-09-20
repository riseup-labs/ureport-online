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
import 'opinion_item.dart';
import 'statistics_location_spinner.dart';

class Opinion extends StatefulWidget {
  const Opinion({Key? key}) : super(key: key);

  @override
  _OpinionState createState() => _OpinionState();
}

class _OpinionState extends State<Opinion>{

  var isLoaded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ResultOpinionLocal>? opinions = [];
    var sp = locator<SPUtil>();
    // Provider.of<OpinionController>(context, listen: false).getOpinionsFromRemote(
    //     RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
    //     sp.getValue(SPUtil.PROGRAMKEY));

    return Consumer<OpinionController>(builder: (context, provider, child) {

      print("Check Data : ${provider.opinionTitle}");
      print("Check Data early: ${provider.opinionTitleEarlier}");
      if(provider.opinionTitle != provider.opinionTitleEarlier){
        isLoaded = true;
      }

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
                            provider.opinions = opinions![0];
                            provider.opinionTitle = opinions![0].title;
                            provider.opinionTitleEarlier = provider.opinionTitle;
                            provider.getQuestionsFromLocal(provider.opinionTitleEarlier);
                            snapshot.data!.clear();
                            isLoaded = false;
                          }
                        }
                      }
                      return snapshot.hasData && provider.questionList.length>0?Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            provider.opinions != null ? StatisticsHeader.getHeadingStatistics(provider.questionList[0],provider.opinions!,provider):Container(),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: provider.questionList.length,
                                itemBuilder: (context, int index) {
                                  return getItem(provider.questionList[index]);
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




  Widget getItem(questionArray.Question question) {

    return OpinionItem(question);
  }

}


