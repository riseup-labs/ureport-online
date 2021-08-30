import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locale/locale_provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/main.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  var sp = locator<SPUtil>();

  static const values = <String>[
    'English',
    'عربي',
    '中國人',
    'français',
    'русский',
    'Española',
  ];

  String selectedValue = "";

  final selectedColor = Colors.lightBlue;
  final unselectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    String already_selected = sp.getValue(SPConstant.SELECTED_LANGUAGE);
    if (already_selected == "") {
      selectedValue = values.first;
    } else if (already_selected == "en") {
      selectedValue = values[0];
    } else if (already_selected == "ar") {
      selectedValue = values[1];
    } else if (already_selected == "zh") {
      selectedValue = values[2];
    } else if (already_selected == "fr") {
      selectedValue = values[3];
    } else if (already_selected == "ru") {
      selectedValue = values[4];
    } else if (already_selected == "es") {
      selectedValue = values[5];
    } else {
      selectedValue = values.first;
    }

    return Scaffold(
      backgroundColor: Color(0xffF5FCFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "${AppLocalizations.of(context)!.language}",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            width: 50,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "${AppLocalizations.of(context)!.select_language}",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                )),
            SizedBox(
              height: 20,
            ),
            buildRadios(provider),
          ],
        ),
      )),
    );
  }

  Widget buildRadios(LocaleProvider provider) => Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: values.map(
            (value) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))),
                        Expanded(
                          flex: 1,
                          child: Radio(
                              value: value,
                              groupValue: selectedValue,
                              activeColor: Colors.lightBlueAccent,
                              onChanged: (value) => {
                                    setState(() => {
                                          this.selectedValue = value.toString(),
                                          if (this.selectedValue == values[0])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "en"),
                                              MyApp.setLocal(provider)
                                            }
                                          else if (this.selectedValue ==
                                              values[1])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "ar"),
                                              MyApp.setLocal(provider)
                                            }
                                          else if (this.selectedValue ==
                                              values[2])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "zh"),
                                              MyApp.setLocal(provider)
                                            }
                                          else if (this.selectedValue ==
                                              values[3])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "fr"),
                                              MyApp.setLocal(provider)
                                            }
                                          else if (this.selectedValue ==
                                              values[4])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "ru"),
                                              MyApp.setLocal(provider)
                                            }
                                          else if (this.selectedValue ==
                                              values[5])
                                            {
                                              sp.setValue(
                                                  SPConstant.SELECTED_LANGUAGE,
                                                  "es"),
                                              MyApp.setLocal(provider)
                                            }
                                        })
                                  }),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: .5,
                        dashLength: 2.0,
                        dashColor: Colors.lightBlueAccent,
                        dashGapLength: 2.0,
                        dashGapColor: Colors.transparent,
                      ),
                    )
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ));
}
