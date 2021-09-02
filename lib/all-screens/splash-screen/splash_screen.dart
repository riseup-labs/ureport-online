import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locale/locale_provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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
            var spset = locator<SPUtil>();
            String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
            if(isSigned!=null){
              NavUtils.pushAndRemoveUntil(context, NavigationScreen());
            }else{
              NavUtils.pushAndRemoveUntil(context, LanguageChooser());
            }
          },
    );

    return Consumer<RemoteConfigController>(
      builder: (context,provider,child){
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
                  child:
                  Image(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/ureport_logo.png"),
                  )
              ),
            ) /* add child content here */,
          ),
        );
      },

    );
    }

}
