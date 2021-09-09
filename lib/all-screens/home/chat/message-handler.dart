/*
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({required this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;
  late Widget child;
  @override
  void initState() {
    super.initState();
    child = widget.child;


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {


      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));

    });

    */
/*fm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message['data']['screen']}");
        String screen = message['data']['screen'];
        if (screen == "secondScreen") {
          Navigator.of(context).pushNamed("secondScreen");
        } else if (screen == "thirdScreen") {
          Navigator.of(context).pushNamed("thirdScreen");
        } else {
          //do nothing
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: ${message['data']['screen']}");
        String screen = message['data']['screen'];
        if (screen == "secondScreen") {
          Navigator.of(context).pushNamed("secondScreen");
        } else if (screen == "thirdScreen") {
          Navigator.of(context).pushNamed("thirdScreen");
        } else {
          //do nothing
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage: ${message['data']['screen']}");
        String screen = message['data']['screen'];
        if (screen == "secondScreen") {
          Navigator.of(context).pushNamed("secondScreen");
        } else if (screen == "thirdScreen") {
          Navigator.of(context).pushNamed("thirdScreen");
        } else {
          //do nothing
        }
      },
    );*//*

  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}*/
