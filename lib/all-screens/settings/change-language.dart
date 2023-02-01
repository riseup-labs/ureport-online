import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locale/locale_provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
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
    // '中國人',
    'Español',
    'Français',
    // 'русский',
    'Italiano',
    'عربي',
  ];

  String selectedValue = "";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    String already_selected = sp.getValue(SPConstant.SELECTED_LANGUAGE)!;

    if (already_selected == "") {
      selectedValue = values.first;
    } else if (already_selected == "en") {
      selectedValue = values[0];
    }
    // else if (already_selected == "zh") {
    //   selectedValue = values[1];
    // }
    // else if (already_selected == "ru") {
    //   selectedValue = values[3];
    // }
    else if (already_selected == "es") {
      selectedValue = values[1];
    } else if (already_selected == "fr") {
      selectedValue = values[2];
    } else if (already_selected == "it") {
      selectedValue = values[3];
    } else if (already_selected == "ar") {
      selectedValue = values[4];
    } else {
      selectedValue = values.first;
    }

    return Scaffold(
      // backgroundColor: Color(0xffF5FCFF),
      body: SafeArea(
          child: Container(
        child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ClickSound.soundClose();
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                height: 70,
                child: Image(
                  height: 60,
                  width: 60,
                  image: AssetImage("assets/images/v2_ic_back.png"),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "${AppLocalizations.of(context)!.select_language}",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: buildRadios(provider)),
            ),
          ],
        ),
      )),
    );
  }

  Widget buildRadiosExtend(LocaleProvider provider) {
    return Container();
  }

  Widget buildRadios(LocaleProvider provider) => Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          margin: EdgeInsets.only(top: 7),
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
                              child: GestureDetector(
                                onTap: () {
                                  ClickSound.soundClick();
                                  selectedValue = value;
                                  print("Radio value : $value");
                                  if (selectedValue == values[0]) {
                                    setLocal(provider, "en");
                                  }
                                  // else if (selectedValue == values[1]) {
                                  //   setLocal(provider, "zh");
                                  // }
                                  else if (this.selectedValue == values[1]) {
                                    setLocal(provider, "es");
                                  } else if (this.selectedValue == values[2]) {
                                    setLocal(provider, "fr");
                                  } else if (this.selectedValue == values[3]) {
                                    setLocal(provider, "it");
                                  }
                                  // else if (this.selectedValue == values[3]) {
                                  //   setLocal(provider, "ru");
                                  // }
                                  else if (this.selectedValue == values[4]) {
                                    setLocal(provider, "ar");
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 3, bottom: 3),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )),
                          Expanded(
                            flex: 1,
                            child: Radio(
                                value: value,
                                groupValue: selectedValue,
                                activeColor: RemoteConfigData.getPrimaryColor(),
                                onChanged: (value) => {
                                      ClickSound.soundClick(),
                                      setState(() => {
                                            this.selectedValue =
                                                value.toString(),
                                            if (this.selectedValue == values[0])
                                              {setLocal(provider, "en")}
                                            // else if (this.selectedValue ==
                                            //     values[1])
                                            //   {setLocal(provider, "zh")}

                                            // else if (this.selectedValue ==
                                            //     values[3])
                                            //   {setLocal(provider, "ru")}
                                            else if (this.selectedValue ==
                                                values[1])
                                              {setLocal(provider, "es")}
                                            else if (this.selectedValue ==
                                                values[2])
                                              {setLocal(provider, "fr")}
                                            else if (this.selectedValue ==
                                                values[3])
                                              {setLocal(provider, "it")}
                                            else if (this.selectedValue ==
                                                values[4])
                                              {setLocal(provider, "ar")}
                                          })
                                    }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      value != values.last
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 22),
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
                          : Container()
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ));

  static void setLocal(LocaleProvider provider, String language) {
    var sp = locator<SPUtil>();
    if (language == "en") {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "en");
      provider.setLocale(new Locale('en'));
    }
    // else if (language == "zh") {
    //   sp.setValue(SPConstant.SELECTED_LANGUAGE, "zh");
    //   provider.setLocale(new Locale('zh'));
    // }
    else if (language == "fr") {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "fr");
      provider.setLocale(new Locale('fr'));
    }
    // else if (language == "ru") {
    //   sp.setValue(SPConstant.SELECTED_LANGUAGE, "ru");
    //   provider.setLocale(new Locale('ru'));
    // }
    else if (language == "es") {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "es");
      provider.setLocale(new Locale('es'));
    } else if (language == "ar") {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "ar");
      provider.setLocale(new Locale('ar'));
    } else if (language == "it") {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "it");
      provider.setLocale(new Locale('it'));
    } else {
      sp.setValue(SPConstant.SELECTED_LANGUAGE, "en");
      provider.setLocale(new Locale('en'));
    }
  }
}
