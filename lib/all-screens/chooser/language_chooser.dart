import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/intro/body.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locale/locale_provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class LanguageChooser extends StatefulWidget {
  const LanguageChooser({Key? key}) : super(key: key);

  @override
  _LanguageChooserState createState() => _LanguageChooserState();
}

class _LanguageChooserState extends State<LanguageChooser> {
  var _dropdownValue = "English";
  String selected_language = "";
  var _sp = locator<SPUtil>();

  @override
  void initState() {
    /*
  'English' en,
  '中國人' zh,
  'Español' es,
  'Français' fr,
  'Romanian' ro,
  'русский' ru,
  'Italiano' it,
  'عربي' ar,                                       
    */
    switch (_sp.getValue(SPConstant.SELECTED_LANGUAGE)) {
      case 'en':
        selected_language = 'en';
        _dropdownValue = "English";
        break;
      case 'ro':
        selected_language = "ro";
        _dropdownValue = "Romanian";
        break;
      case 'zh':
        selected_language = 'zh';
        _dropdownValue = "中國人";
        break;
      case 'es':
        selected_language = 'es';
        _dropdownValue = "Español";
        break;
      case 'fr':
        selected_language = "fr";
        _dropdownValue = "Français";
        break;
      case 'it':
        selected_language = "it";
        _dropdownValue = "Italiano";
        break;
      case 'ru':
        selected_language = 'ru';
        _dropdownValue = "русский";
        break;
      case 'ar':
        selected_language = 'ar';
        _dropdownValue = "عربي";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.mainBgColor,
          body: Container(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 50),
                            height: 55,
                            width: 170,
                            child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/v2_logo_1.png"),
                            )),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: selected_language == "ru" ? 30 : 0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${AppLocalizations.of(context)!.welcome}!",
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontFamily: "Poppins")),
                                  TextSpan(
                                      text:
                                          "\n${AppLocalizations.of(context)!.get_started}",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: "Poppins")),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "${AppLocalizations.of(context)!.select_language}",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _dropdownValue,
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (String? newValue) {
                                        ClickSound.soundClick();
                                        final provider_l =
                                            Provider.of<LocaleProvider>(context,
                                                listen: false);

                                        _dropdownValue = newValue!;
                                        if (_dropdownValue == "English") {
                                          selected_language = "en";
                                          provider_l
                                              .setLocale(new Locale('en'));
                                        } else if (_dropdownValue == "中國人") {
                                          selected_language = "zh";
                                          provider_l
                                              .setLocale(new Locale('zh'));
                                        } else if (_dropdownValue ==
                                            "Français") {
                                          selected_language = "fr";
                                          provider_l
                                              .setLocale(new Locale('fr'));
                                        } else if (_dropdownValue ==
                                            "Romanian") {
                                          selected_language = "ro";
                                          provider_l
                                              .setLocale(new Locale('ro'));
                                        } else if (_dropdownValue ==
                                            "русский") {
                                          selected_language = "ru";
                                          provider_l
                                              .setLocale(new Locale('ru'));
                                        } else if (_dropdownValue ==
                                            "Español") {
                                          selected_language = "es";
                                          provider_l
                                              .setLocale(new Locale('es'));
                                        } else if (_dropdownValue == "عربي") {
                                          selected_language = "ar";
                                          provider_l
                                              .setLocale(new Locale('ar'));
                                        } else if (_dropdownValue ==
                                            "Italiano") {
                                          selected_language = "it";
                                          provider_l
                                              .setLocale(new Locale('it'));
                                        } else {
                                          selected_language = "en";
                                          provider_l
                                              .setLocale(new Locale('en'));
                                        }
                                        _sp.setValue(
                                            SPConstant.SELECTED_LANGUAGE,
                                            selected_language);
                                        setState(() {});
                                      },
                                      items: <String>[
                                        'English',
                                        '中國人',
                                        'Español',
                                        'Français',
                                        'Romanian',
                                        'русский',
                                        'Italiano',
                                        'عربي',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          onTap: () {},
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onTap: () {
                                        ClickSound.soundDropdown();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 70),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: Container(
                              child: GestureDetector(
                            onTap: () {
                              ClickSound.soundClick();
                              final provider_l = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);
                              if (selected_language == 'en') {
                                provider_l.setLocale(new Locale('en'));
                              } else if (selected_language == 'zh') {
                                provider_l.setLocale(new Locale('zh'));
                              } else if (selected_language == 'fr') {
                                provider_l.setLocale(new Locale('fr'));
                              } else if (selected_language == 'ro') {
                                provider_l.setLocale(new Locale('ro'));
                              } else if (selected_language == 'ru') {
                                provider_l.setLocale(new Locale('ru'));
                              } else if (selected_language == 'es') {
                                provider_l.setLocale(new Locale('es'));
                              } else if (selected_language == 'ar') {
                                provider_l.setLocale(new Locale('ar'));
                              } else if (selected_language == 'it') {
                                provider_l.setLocale(new Locale('it'));
                              } else {
                                provider_l.setLocale(new Locale('en'));
                              }
                              _sp.setValue(SPConstant.SELECTED_LANGUAGE,
                                  selected_language);
                              NavUtils.push(context, IntroScreen());
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.continu,
                                style: TextStyle(
                                    fontSize: 20,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
