import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/intro/intro_screen.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2), () => NavUtils.pushAndRemoveUntil(context,LanguageChooser()),
    );

    return Scaffold(
    body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image:
    AssetImage("assets/images/drawable-ldpi/bg_splash_screen.png"),
    fit: BoxFit.cover,
    ),
    ),
    child: Center(
    child: Container(
    height: 42,
    width: 210,
    child:
    Image(
    fit: BoxFit.fill,
    image: AssetImage("assets/images/drawable-ldpi/ureport_logo.png"),
    )
    ),
    ) /* add child content here */,
    ),
    );
    }
}
