import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response_opinions.dart' as questionArray;
import 'model/response_opinions.dart';
import 'opinion_controller.dart';

class StatisticsLocationSpinner extends StatefulWidget {
  questionArray.Question question;
  Color color;

  StatisticsLocationSpinner(this.question, this.color);

  @override
  _StatisticsLocationSpinnerState createState() =>
      _StatisticsLocationSpinnerState(question, color);
}

class _StatisticsLocationSpinnerState extends State<StatisticsLocationSpinner> {
  questionArray.Question question;
  Color color;
  _StatisticsLocationSpinnerState(this.question, this.color);

  List<ResultsByLocation> resultsByLocation = [];

  String dropdownValue = "";
  late ResultsByLocation location;
  var isLoaded = true;

  @override
  Widget build(BuildContext context) {
    var sp = locator<SPUtil>();
    List<DropdownMenuItem<String>> countryList = [];
    List<String> countries = [];

    resultsByLocation.clear();
    resultsByLocation.addAll(question.resultsByLocation);
    resultsByLocation.sort((a, b) => a.label.compareTo(b.label));

    resultsByLocation.forEach((element) {
      countries.add(element.label);
      countryList.add(DropdownMenuItem(
        value: element.label,
        child: Text(element.label),
      ));
    });

    countries.sort();

    if (isLoaded) {
      location = question.resultsByLocation[0];
      dropdownValue = countries[0];
      isLoaded = false;
    }
    return Consumer<OpinionController>(builder: (context, provider, snapshot) {
      return Column(
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            onChanged: (String? newValue) {
              ClickSound.soundClick();
              dropdownValue = newValue!;
              // print("the value is : $dropdownValue");
              resultsByLocation.forEach((element) {
                if (element.label == dropdownValue) {
                  location = element;
                }
              });
              setState(() {});
            },
            items: countryList,
            onTap: () {
              ClickSound.soundDropdown();
            },
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: location.categories.length,
              itemBuilder: (context, index) {
                int set = location.resultsByLocationSet;
                int count = location.categories[index].count;
                return Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: LinearPercentIndicator(
                          animation: false,
                          lineHeight: 28.0,
                          backgroundColor: Colors.white,
                          percent: set != 0 ? count / set : 0.0,
                          center: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                      "${location.categories[index].label}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                            ],
                          ),
                          barRadius: const Radius.circular(8),
                          // linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: color,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                              "${((set != 0 ? count / set : 0.0) * 100).round()}%"),
                        ),
                      ),
                    ),
                  ],
                );
              })
        ],
      );
    });
  }
}
