import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/program_chooser.dart';
import 'package:ureport_ecaro/all-screens/settings/change-language.dart';
import 'package:ureport_ecaro/all-screens/settings/privacy_policy.dart';
import 'package:ureport_ecaro/all-screens/settings/settings_details.dart';
import 'package:ureport_ecaro/all-screens/settings/terms_and_conditions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';

import 'about/about.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          width: double.infinity,
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 50,
                ),
                child: Text(
                  "${AppLocalizations.of(context)!.more}",
                  style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  ClickSound.buttonClickYes();
                  NavUtils.push(context, SettingDetails());
                },
                child: getItem(
                    "${AppLocalizations.of(context)!.settings}", "assets/images/v2_ic_settings.png"),
              ),
              GestureDetector(
                onTap: () {
                  ClickSound.buttonClickYes();
                  NavUtils.push(context, About());
                },
                child: getItem(
                    "${AppLocalizations.of(context)!.about_us}", "assets/images/v2_ic_about.png"),
              ),
              GestureDetector(
                onTap: () {
                  ClickSound.buttonClickYes();
                  NavUtils.push(context, ChangeLanguage());
                },
                child: getItem("${AppLocalizations.of(context)!.change_language}",
                    "assets/images/v2_ic_language.png"),
              ),
              GestureDetector(
                onTap: () {
                  ClickSound.buttonClickYes();
                  NavUtils.push(context, ProgramChooser("more"));
                },
                child: getItem("${AppLocalizations.of(context)!.change_ureport_program}",
                    "assets/images/v2_ic_program.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getItem(String title, String image) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topLeft: Radius.circular(5),topRight: Radius.circular(5),bottomRight: Radius.circular(20)),
        color: RemoteConfigData.getBackgroundColor(),
      ),

      padding: EdgeInsets.only(left: 10, right: 15),
      margin: EdgeInsets.only(top: 15, left: 30,right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, color: RemoteConfigData.getTextColor()),
            ),
          ),
          Container(
            height: 35,
            width: 35,
            child: Image(
              color:  RemoteConfigData.getTextColor(),
              image: AssetImage(image),
            ),
          ),
        ],
      ),
    );
  }
}
