import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class BannerScreen extends StatefulWidget {

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {

  @override
  void initState() {

    Provider.of<RemoteConfigController>(context,listen: false).getInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(seconds: 2),
          () {
            NavUtils.pushAndRemoveUntil(context, LanguageChooser());
          },
    );

    return Consumer<RemoteConfigController>(
      builder: (context,provider,child){
        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  AssetImage("assets/images/v2_splash_screen_3.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(),
            ),
          ),
        );
      },

    );
    }

}
