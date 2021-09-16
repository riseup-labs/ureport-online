import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/chat/Chat.dart';
import 'package:ureport_ecaro/all-screens/home/chat/model/golbakey.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/firebase-remote-config/response-remote-config-data.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class RemoteConfigController extends ChangeNotifier {

  var sp = locator<SPUtil>();

  late ResponseRemoteConfigData remoteConfigData;




  getInitialData(BuildContext context) async {
    RemoteConfig remoteConfig = RemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 10),
    ));

    await remoteConfig.fetchAndActivate();
    if (remoteConfig.getString("values").isNotEmpty) {
      var firebasedata = remoteConfig.getString("values");
      var data = ResponseRemoteConfigData.fromJson(json.decode(firebasedata));
      remoteConfigData = data;
      sp.setValue(SPConstant.ALL_PROGRAMS, firebasedata);
    }

    notifyListeners();
  }

/*  getfirebaseInitialmessage(BuildContext context){
    FirebaseMessaging.instance
        .getInitialMessage().then((RemoteMessage? remotemessage) {


          if(remotemessage!.notification!.body!=null){
            List<dynamic> quicktypest;
            if(remotemessage!.data["quick_replies"]!=null){
              quicktypest = json.decode(remotemessage.data["quick_replies"]);
            }else{
              quicktypest=[""];
            }
            print("the notification message is ${remotemessage.notification!.body}");
            MessageModel notificationmessage_terminatestate = MessageModel(sender: 'server',message: remotemessage.notification!.body,status: "received",quicktypest: quicktypest);


            NavUtils.pushAndRemoveUntil(context, NavigationScreen(notificationmessage_terminatestate));
          }


    });
  }*/



}
