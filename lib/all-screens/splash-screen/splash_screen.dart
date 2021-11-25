import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/chat/Chat.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
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
    Provider.of<ConnectivityController>(context, listen: false)
        .startMonitoring();
    Provider.of<RemoteConfigController>(context, listen: false)
        .getInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFirebaseInitialMessage(context);
    getfirebaseonApp(context);
    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
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
                    image: AssetImage("assets/images/v2_logo_2.png"),
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          margin:
                              EdgeInsets.only(top: 50, left: 30, right: 30),
                          child: Text(
                            AppLocalizations.of(context)!.splashText,
                            style: TextStyle(
                              fontSize: (AppLocalizations.of(context)!.splashText).length <= 28 ? 48 : 40,
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
      },
    );
  }

  getFirebaseInitialMessage(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remotemessage) {
      if (remotemessage != null) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
        List<dynamic> quicktypest;
        if (remotemessage.data["quick_replies"] != null) {
          quicktypest = json.decode(remotemessage.data["quick_replies"]);
        } else {
          quicktypest = [""];
        }
        var notificationmessage_terminatestate = MessageModel(
            sender: 'server',
            message: remotemessage.notification!.body,
            status: "received",
            quicktypest: quicktypest,
            time: formattedDate);

        locator<SPUtil>().setValue(SPUtil.PROGRAMKEY, remotemessage.notification!.title!);

        Provider.of<ChatController>(context, listen: false)
            .addMessageFromPushNotification(notificationmessage_terminatestate,remotemessage.notification!.title!);
        Provider.of<ChatController>(context, listen: false).isMessageCome =
            false;
        print("Remote message : $remotemessage");
        senDToChat();
      } else {
        print("Remote message : $remotemessage");
        senDToHome();
      }
    });
  }

  getfirebaseonApp(context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      print("Navigation screen called");
      if(remoteMessage != null){
        NavUtils.pushReplacement(context, Chat("notification"));
      }
    });
  }

  senDToChat() {
    Timer(
      Duration(seconds: 2),
      () {
        var spset = locator<SPUtil>();
        String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
        if (isSigned != null) {
          NavUtils.pushAndRemoveUntil(context, Chat("notification"));
        } else {
          NavUtils.pushAndRemoveUntil(context, LanguageChooser());
        }
      },
    );
  }

  senDToHome() {
    Timer(
      Duration(seconds: 2),
      () {
        var spset = locator<SPUtil>();
        String isSigned = spset.getValue(SPUtil.PROGRAMKEY);
        if (isSigned != null) {
            NavUtils.pushAndRemoveUntil(context, NavigationScreen(0));
        } else {
          if (Provider.of<ConnectivityController>(context, listen: false).isOnline) {

            NavUtils.pushAndRemoveUntil(context, LanguageChooser());

          }else{
            noInternetDialog();
          }
        }
      },
    );
  }

  noInternetDialog() {
    AlertDialog alert = AlertDialog(
      content: Text("No internet connection is available"),
      actions: [
        TextButton(
          child: Text("EXIT",style: TextStyle(color: Colors.red),),
          onPressed: () {
            ClickSound.soundClick();
            Navigator.of(context).pop();
            SystemNavigator.pop();
          },
        ),
        TextButton(
          child: Text("RETRY"),
          onPressed: () {
            ClickSound.soundClick();
            Navigator.of(context).pop();
            NavUtils.pushAndRemoveUntil(context, SplashScreen());
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
