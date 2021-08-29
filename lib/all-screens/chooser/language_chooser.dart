import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/intro/intro_screen.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locale/locale_provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class LanguageChooser extends StatefulWidget {
  const LanguageChooser({Key? key}) : super(key: key);

  @override
  _LanguageChooserState createState() => _LanguageChooserState();
}

class _LanguageChooserState extends State<LanguageChooser> {
  var dropdownValue = "English";
  String selected_language = "";

  var _sp = locator<SPUtil>();

  @override
  Widget build(BuildContext context) {

    return Consumer<RemoteConfigController>(
      builder: (context,provider,child){
        return SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/drawable-xxhdpi/bg_select_language.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              AppLocalizations.of(context)!.welcome,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          getLogo()
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
                                Text(
                                  "${AppLocalizations.of(context)!.select_language}",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValue = newValue!;
                                              if(dropdownValue == "English"){
                                                selected_language = "en";
                                              }else if(dropdownValue == "Española"){
                                                selected_language = "es";
                                              }else{
                                                selected_language = "es";
                                              }
                                            });
                                          },
                                          items: <String>[
                                            'English',
                                            'عربي',
                                            '中國人',
                                            'français',
                                            'русский',
                                            'Española',
                                          ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  onTap: (){

                                                  },
                                                  child: Text(value),
                                                );
                                              }).toList(),

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
                                child: ElevatedButton(
                                  onPressed: () {
                                    final provider_l = Provider.of<LocaleProvider>(context, listen: false);
                                    print(selected_language);
                                    if(selected_language == 'en'){
                                      provider_l.setLocale(new Locale('en'));
                                    }else if(selected_language == 'es'){
                                      provider_l.setLocale(new Locale('es'));
                                    }else{
                                      provider_l.setLocale(new Locale('en'));
                                    }
                                    _sp.setValue(SPConstant.SELECTED_LANGUAGE, selected_language);
                                    NavUtils.push(context, NavigationScreen());
                                  },
                                  child: Text(AppLocalizations.of(context)!.continu),
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder()),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  getLogo() {
    return Container(
        height: 42,
        width: 210,
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/drawable-ldpi/ureport_logo.png"),
        ));
  }
}
