import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
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

class OpinionScreenFromSearch extends StatefulWidget {
  const OpinionScreenFromSearch({Key? key}) : super(key: key);

  @override
  _OpinionScreenFromSearchState createState() =>
      _OpinionScreenFromSearchState();
}

var count = 0;

class _OpinionScreenFromSearchState extends State<OpinionScreenFromSearch> {
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
      var _futureOpinion = provider.getOpinionsFromLocal(
          sp.getValue(SPUtil.PROGRAMKEY)!, provider.opinionID);
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 0.0,
          ),
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 70,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        child: IconButton(
                                          icon: Container(
                                              child: Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/v2_ic_back.png"),
                                          )),
                                          color: Colors.black,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ClickSound.soundClose();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Center(
                                          child: getShareButton(
                                              "${provider.opinionID}"),
                                        ),
                                      ))
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: CustomPaint(
                                  painter: CustomBackground(),
                                  child: Container(
                                    height: 80,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .opinions,
                                          style: TextStyle(
                                              fontSize: 26.0,
                                              color: RemoteConfigData
                                                  .getTextColor(),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Divider(
                          height: 1,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Divider(
                      height: 1,
                      color: Colors.grey[600],
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
                              List<questionArray.Question> questionList =
                                  (mapdata as List)
                                      .map((e) =>
                                          questionArray.Question.fromJson(e))
                                      .toList();
                              return snapshot.hasData
                                  ? RefreshIndicator(
                                      onRefresh: () {
                                        return _futureOpinion =
                                            getDataFromApi(context, provider);
                                      },
                                      child: SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              questionList.length > 0
                                                  ? StatisticsHeader
                                                      .getHeadingStatistics(
                                                          questionList[0],
                                                          opinions![0],
                                                          provider,
                                                          sp.getValue(SPUtil
                                                              .PROGRAMKEY)!,
                                                          context)
                                                  : StatisticsHeader
                                                      .getHeadingStatisticsEmpty(
                                                          opinions![0],
                                                          context),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount:
                                                      questionList.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (colorNumber >
                                                        colors.length - 1) {
                                                      colorNumber = 0;
                                                    }
                                                    return OpinionItem(
                                                        questionList[index],
                                                        colors[questionList[
                                                                        index]
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

  getShareButton(String id) {
    return GestureDetector(
      onTap: () async {
        ClickSound.soundClick();
        await Share.share("${RemoteConfigData.getOpinionShareUrl()}" + id);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.share,
              style: TextStyle(
                  fontSize: 15, color: RemoteConfigData.getPrimaryColor()),
            ),
            SizedBox(
              width: 5,
            ),
            Image(
              image: AssetImage("assets/images/ic_share.png"),
              height: 17,
              width: 17,
              color: RemoteConfigData.getPrimaryColor(),
            )
          ],
        ),
      ),
    );
  }
}
