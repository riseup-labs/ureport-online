import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/load_data_handling.dart';
import 'package:ureport_ecaro/utils/loading_bar.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/snackbar.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
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

    if (Provider.of<OpinionController>(context, listen: false).isLoaded) {
      Provider.of<OpinionController>(context, listen: false).checkOpinion(
          RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
          sp.getValue(SPUtil.PROGRAMKEY)!);
      Provider.of<OpinionController>(context, listen: false).isLoaded = false;
    }

    return Consumer<OpinionController>(builder: (context, provider, child) {
      var _futureOpinion =
          provider.getOpinionsFromLocal(sp.getValue(SPUtil.PROGRAMKEY)!, 0);
      return Scaffold(
          body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar.getTopBar(AppLocalizations.of(context)!.opinions),
              Container(
                child: Divider(
                  height: 1,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              provider.isSyncing
                  ? Container(
                      height: 5,
                      padding: EdgeInsets.only(left: 13, right: 13),
                      child: LinearProgressIndicator(
                        color: RemoteConfigData.getPrimaryColor(),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    ClickSound.soundClick();
                    NavUtils.push(context, OpinionSearch());
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.search,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                              size: 38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<ResultOpinionLocal>>(
                    future: _futureOpinion,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        opinions = snapshot.data;
                        if (opinions!.length > 0) {
                          var mapdata = jsonDecode(opinions![0].questions!);
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
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          questionList.length > 0
                                              ? StatisticsHeader
                                                  .getHeadingStatistics(
                                                      questionList.first,
                                                      opinions![0],
                                                      provider,
                                                      sp.getValue(
                                                          SPUtil.PROGRAMKEY)!,
                                                      context)
                                              : StatisticsHeader
                                                  .getHeadingStatisticsEmpty(
                                                      opinions![0], context),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: questionList.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                if (colorNumber >
                                                    colors.length - 1) {
                                                  colorNumber = 0;
                                                }
                                                return OpinionItem(
                                                    questionList[index],
                                                    colors[questionList[index]
                                                                .resultsByGender
                                                                .length !=
                                                            0
                                                        ? colorNumber++
                                                        : colorNumber]);
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 60,
                                  width: 60,
                                  child: LoadingBar.spinkit,
                                );
                        } else {
                          return Container(
                            height: 60,
                            width: 60,
                            child: LoadingBar.spinkit,
                          );
                        }
                      } else {
                        return Container(
                          height: 60,
                          width: 60,
                          child: LoadingBar.spinkit,
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ));
    });
  }

  Future<dynamic> getDataFromApi(
      BuildContext context, OpinionController provider) async {
    if (provider.isOnline) {
      Provider.of<OpinionController>(context, listen: false).setSyncing();
      Provider.of<OpinionController>(context, listen: false).isLoading = false;
      return Provider.of<OpinionController>(context, listen: false)
          .checkOpinion(
              RemoteConfigData.getOpinionUrl(sp.getValue(SPUtil.PROGRAMKEY)),
              sp.getValue(SPUtil.PROGRAMKEY)!);
    } else {
      return ShowSnackBar.showNoInternetMessage(context);
    }
  }
}
