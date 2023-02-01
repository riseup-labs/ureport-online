import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class IntroPageFirst extends StatefulWidget {
  const IntroPageFirst({Key? key}) : super(key: key);

  @override
  _IntroPageFirstState createState() => _IntroPageFirstState();
}

class _IntroPageFirstState extends State<IntroPageFirst> {
  @override
  void initState() {
    senDToLanguageChooser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/v2_splash_screen2.png"),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 40,
            child: Container(
              height: 65,
              width: 200,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/v2_logo_1.png"),
              ),
            ),
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 50, left: 30, right: 30),
                      child: Text(
                        AppLocalizations.of(context)!.splashText,
                        style: TextStyle(
                          fontSize: (AppLocalizations.of(context)!.splashText)
                                      .length <=
                                  28
                              ? 48
                              : 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  senDToLanguageChooser() {
    Timer(
      Duration(seconds: 3),
      () {
        NavUtils.pushAndRemoveUntil(context, LanguageChooser());
      },
    );
  }
}
