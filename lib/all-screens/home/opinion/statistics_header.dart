import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/number_format.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response-opinion-localdb.dart';
import 'model/response_opinions.dart' as questionArray;
import 'opinion_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsHeader {
  static Widget getHeadingStatistics(
      questionArray.Question question,
      ResultOpinionLocal opinions,
      OpinionController provider,
      String program,
      BuildContext context) {
    var sp = locator<SPUtil>();

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
    int totalRespondents = question.results.resultsSet + question.results.unset;
    double responseRate = (respondents / totalRespondents) * 100;
    if (question.resultsByGender.length == 3) {
      int guysSet = question.resultsByGender[2].resultsSet;
      int femaleSet = question.resultsByGender[1].resultsSet;
      int maleSet = question.resultsByGender[0].resultsSet;

      int gendeTotal = guysSet + femaleSet + maleSet;

      guysRespondent = guysSet;
      maleRespondent = maleSet;
      femaleRespondent = femaleSet;

      guysResponseRate = (guysSet / gendeTotal) * 100;
      maleResponseRate = (maleSet / gendeTotal) * 100;
      femaleResponseRate = (femaleSet / gendeTotal) * 100;
    } else {
      if (question.resultsByGender.length > 0) {
        int femaleSet = question.resultsByGender[1].resultsSet;
        int maleSet = question.resultsByGender[0].resultsSet;

        maleRespondent = maleSet;
        femaleRespondent = femaleSet;
        int genderTotal = maleSet + femaleSet;

        maleResponseRate = (maleSet / genderTotal) * 100;
        femaleResponseRate = (femaleSet / genderTotal) * 100;
      } else {
        maleRespondent = 0;
        femaleRespondent = 0;

        maleResponseRate = 0;
        femaleResponseRate = 0;
      }
    }

    String latest_opinion_id =
        sp.getValue("${sp.getValue(SPUtil.PROGRAMKEY)}_latest_opinion")!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        latest_opinion_id == opinions.id.toString()
            ? Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  AppLocalizations.of(context)!.latest_opinion,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : Container(),
        Container(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: RemoteConfigData.getPrimaryColor(),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  category,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                )),
            SizedBox(
              width: 15,
            ),
            Text(
              clockString,
              style: TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          child: Divider(
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "${FormattedNumber.formatNumber(respondents)}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)!.respondents,
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
                    AppLocalizations.of(context)!.response_rate,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        question.resultsByGender.length != 0
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/images/male.png",
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${question.resultsByGender.length > 0 ? question.resultsByGender[0].label : "-"}",
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
                          height: 63,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${maleResponseRate.round().toString()}%",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Text(
                                "${FormattedNumber.formatNumber(maleRespondent)}",
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
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/images/female.png",
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${question.resultsByGender.length > 0 ? question.resultsByGender[1].label : "-"}",
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
                          height: 63,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${femaleResponseRate.round().toString()}%",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Text(
                                "${FormattedNumber.formatNumber(femaleRespondent)}",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  question.resultsByGender.length == 3
                      ? Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 65,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "assets/images/gender_other.png",
                                      height: 35,
                                      width: 35,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${question.resultsByGender.length > 0 ? question.resultsByGender[2].label : "-"}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 63,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${guysResponseRate.round().toString()}%",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    Text(
                                      "${FormattedNumber.formatNumber(guysRespondent)}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              )
            : Container(),
        SizedBox(
          height: question.resultsByGender.length != 0 ? 15 : 0,
        ),
        Container(
          child: Divider(
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  static Widget getHeadingStatisticsEmpty(
      ResultOpinionLocal opinions, BuildContext context) {
    String title = opinions.title.replaceAll("\n", " ");
    title = title.replaceAll("\r", " ");

    String category = opinions.category.toUpperCase();
    final dateTime = DateTime.parse(opinions.polldate);
    final format = DateFormat('dd MMMM, yyyy');
    final clockString = format.format(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  category,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                )),
            SizedBox(
              width: 15,
            ),
            Text(
              clockString,
              style: TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          child: Divider(
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "---",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)!.respondents,
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
                    "0%",
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
                    height: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/male.png",
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "---",
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
                    height: 63,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "0%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "---",
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
                    height: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/female.png",
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "---",
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
                    height: 63,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "0%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "0",
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
                    height: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/gender_other.png",
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "---",
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
                    height: 63,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "0%",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "0",
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
}
