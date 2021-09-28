import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/load_data_handling.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/snackbar.dart';
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

  var sp = locator<SPUtil>();
  List<Color> colors = RemoteConfigData.getSecondaryColorList();
  int colorNumber = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<OpinionController>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    List<ResultOpinionLocal>? opinions = [];

    if (LoadDataHandling.checkOpinionLoadAvailability()) {
      Provider.of<OpinionController>(context, listen: false)
          .getOpinionsFromRemote(
          RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
          sp.getValue(SPUtil.PROGRAMKEY));
    } else {
      print("Load : false");
    }

    return Consumer<OpinionController>(builder: (context, provider, child) {
      var _futureOpinion = provider.getOpinionsFromLocal(
          sp.getValue(SPUtil.PROGRAMKEY), provider.opinionID);

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
                  child: CachedNetworkImage(
                    imageUrl: RemoteConfigData.getLargeIcon(),
                    height: 30,
                    width: 150,
                  )),
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
              provider.isLoading
                  ? Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(15),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: FutureBuilder<List<ResultOpinionLocal>>(
                    future: _futureOpinion,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        opinions = snapshot.data;
                        if (opinions!.length > 0) {
                          var mapdata = jsonDecode(opinions![0].questions);
                          // questionList.clear();
                          List<questionArray.Question> questionList = (mapdata
                                  as List)
                              .map((e) => questionArray.Question.fromJson(e))
                              .toList();
                          return snapshot.hasData
                              ? RefreshIndicator(
                                  onRefresh: () {
                                    return _futureOpinion =
                                        getDataFromApi(context, provider);
                                  },
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
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
                                                if(colorNumber > colors.length-1){
                                                  colorNumber = 0;
                                                }
                                                return OpinionItem(questionList[index],colors[questionList[index].resultsByGender.length != 0? colorNumber++ : colorNumber]);
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : !provider.isLoading?Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(15),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ):Container();
                        } else {
                          return !provider.isLoading?Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(15),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ):Container();
                        }
                      } else {
                        return !provider.isLoading?Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ):Container();
                      }
                    }),
              )
            ],
          ),
        ),
      )));
    });
  }

  Future<String?> getDataFromApi(
      BuildContext context, OpinionController provider) async {
    if (provider.isOnline) {
      return Provider.of<OpinionController>(context, listen: false)
          .getOpinionsFromRemote(
              RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
              sp.getValue(SPUtil.PROGRAMKEY));
    } else {
      return ShowSnackBar.showNoInternetMessage(context);
    }
  }
}
