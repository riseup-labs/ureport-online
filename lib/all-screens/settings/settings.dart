import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/chooser/program_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/more/select-language.dart';
import 'package:ureport_ecaro/all-screens/settings/privacy_policy.dart';
import 'package:ureport_ecaro/all-screens/settings/terms_and_conditions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';

import 'about.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/drawable-ldpi/bg_home.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "${AppLocalizations.of(context)!.more}",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: getItem(
                    "${AppLocalizations.of(context)!.settings}", "assets/images/drawable-ldpi/ic_settings.png"),
              ),
              GestureDetector(
                onTap: () {
                  NavUtils.push(context, About());
                },
                child: getItem(
                    "${AppLocalizations.of(context)!.about_us}", "assets/images/drawable-ldpi/ic_about.png"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProgramChooser();
                      },
                    ),
                  );

                },
                child: getItem("${AppLocalizations.of(context)!.change_ureport_program}",
                    "assets/images/drawable-ldpi/ic_change_ureport_program.png"),
              ),
              GestureDetector(
                onTap: () {

                  NavUtils.push(context, SelectLanguage());
                },
                child: getItem("${AppLocalizations.of(context)!.change_language}",
                    "assets/images/drawable-ldpi/ic_change_language.png"),
              ),
              GestureDetector(
                onTap: () {},
                child: getItem(
                    "${AppLocalizations.of(context)!.feedback}", "assets/images/drawable-ldpi/ic_feedback.png"),
              ),
              GestureDetector(
                onTap: () {
                  NavUtils.push(context, PrivacyPolicy());
                },
                child: getItem("${AppLocalizations.of(context)!.privacy_policy}",
                    "assets/images/drawable-ldpi/ic_privacy_policy.png"),
              ),
              GestureDetector(
                onTap: () {
                  NavUtils.push(context, Terms());
                },
                child: getItem("${AppLocalizations.of(context)!.terms}",
                    "assets/images/drawable-ldpi/ic_terms_and_conditions.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getItem(String title, String image) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 30),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            child: Image(
              image: AssetImage(image),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.black),
          )
        ],
      ),
    );
  }
}
