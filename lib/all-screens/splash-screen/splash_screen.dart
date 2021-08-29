import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(seconds: 2),
          () => NavUtils.pushAndRemoveUntil(context, LanguageChooser()),
    );

    getInitialData(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/bg_splash_screen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
              height: 42,
              width: 210,
              child: Image(
                fit: BoxFit.fill,
                image:
                    AssetImage("assets/images/ureport_logo.png"),
              )),
        ) /* add child content here */,
      ),
    );
  }

  getInitialData(BuildContext context) async {

    RemoteConfig remoteConfig = RemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 10),
    ));

    bool updated = await remoteConfig.fetchAndActivate();
    if (updated) {
      Timer(
        Duration(seconds: 2),
            () => NavUtils.pushAndRemoveUntil(context, LanguageChooser()),
      );
    } else {
      print("old data is showing");
    }

  }
}
