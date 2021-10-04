import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Provider.of<RemoteConfigController>(context, listen: false)
        .getInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getfirebaseInitialmessage(context).then((value) =>{
    //   if(value==true){
    //     Timer(
    //       Duration(seconds: 2),
    //           () {
    //         var spset = locator<SPUtil>();
    //         String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
    //         if (isSigned != null) {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => NavigationScreen(1)));
    //         } else {
    //           NavUtils.pushAndRemoveUntil(context, BannerScreen());
    //         }
    //       },
    //     )
    //   }else{
    //     Timer(
    //       Duration(seconds: 2),
    //           () {
    //         var spset = locator<SPUtil>();
    //         String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
    //         if (isSigned != null) {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => NavigationScreen(1)));
    //         } else {
    //           NavUtils.pushAndRemoveUntil(context, BannerScreen());
    //         }
    //       },
    //     )
    //
    //   }
    // });
    //
    // getfirebaseonApp(context).then((value) => {
    //   if(value==true){
    //     Timer(
    //       Duration(seconds: 2),
    //           () {
    //         var spset = locator<SPUtil>();
    //         String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
    //         if (isSigned != null) {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => NavigationScreen(1)));
    //         } else {
    //           NavUtils.pushAndRemoveUntil(context, BannerScreen());
    //         }
    //       },
    //     )
    //   }else{
    //     Timer(
    //       Duration(seconds: 2),
    //           () {
    //         var spset = locator<SPUtil>();
    //         String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
    //         if (isSigned != null) {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => NavigationScreen(0)));
    //         } else {
    //           NavUtils.pushAndRemoveUntil(context, BannerScreen());
    //         }
    //       },
    //     )
    //   }
    // });

    Timer(
      Duration(seconds: 2),
      () {
        var spset = locator<SPUtil>();
        String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
        if (isSigned != null) {
          NavUtils.pushAndRemoveUntil(context, NavigationScreen(0));
        } else {
          NavUtils.pushAndRemoveUntil(context, LanguageChooser());
        }
      },
    );

    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image(
                        fit: BoxFit.fill,
                        image:
                        AssetImage("assets/images/v2_splash_screen2.png"),
                      ),
                    )),
                Positioned(
                  bottom: 60,
                  right: 40,
                  child: Container(
                    height: 65,
                    width: 200,
                    child: Image(
                      fit: BoxFit.fill,
                      image:
                      AssetImage("assets/images/v2_logo_2.png"),
                    ),
                  ),
                ),
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(top: 40,left: 30, right: 30),
                            child: Text(AppLocalizations.of(context)!.splashText, style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w800,),)
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> getfirebaseInitialmessage(BuildContext context) async {
    bool isDataExist = false;
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remotemessage) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
      List<dynamic> quicktypest;
      if (remotemessage!.data["quick_replies"] != null) {
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      } else {
        quicktypest = [""];
      }
      //print("the notification message is ${remotemessage.notification!.body}");
      var notificationmessage_terminatestate = MessageModel(
          sender: 'server',
          message: remotemessage.notification!.body,
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);

      Provider.of<ChatController>(context, listen: false)
          .addMessage(notificationmessage_terminatestate);
      if (remotemessage.notification!.body != null) {
        isDataExist = true;
      } else {
        isDataExist = false;
      }
    });
    return isDataExist;
  }

  Future<bool> getfirebaseonApp(context) async {
    bool isDataExist = false;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
      List<dynamic> quicktypest;
      if (remotemessage.data["quick_replies"] != null) {
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      } else {
        quicktypest = [""];
      }
      //print("the notification message is ${remotemessage.notification!.body}");
      var notificationmessage = MessageModel(
          sender: 'server',
          message: remotemessage.notification!.body,
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);

      Provider.of<ChatController>(context, listen: false)
          .addMessage(notificationmessage);
      if (remotemessage.notification!.body != null) {
        isDataExist = true;
      } else {
        isDataExist = false;
      }
    });
    return isDataExist;
  }
}
