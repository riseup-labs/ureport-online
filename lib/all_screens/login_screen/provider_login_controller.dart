

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ureport_ecaro/generic_model/return_obj.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';

import '../../main.dart';

class ProviderLoginController extends ChangeNotifier{

  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  late ResponseContactCreation responseContactCreation;
  var _urn="";

   String _token ="";
  getToken() async {


    _token = (await FirebaseMessaging.instance.getToken())!;
    //print("this is firebase fcm token ==  ${_token}");
  }

  createContatct() async {
     await getToken();
      if(_token.isNotEmpty){
        print("this is firebase fcm token ==  ${_token}");
         var apiResponse = await _rapidproservice.createContact("nur456", _token,onSuccess:(uuid){
           contatct=uuid;
         } );
          // getfirebase();
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;

         /* FirebaseMessaging.onMessage.listen((event) {

           // MessageModel(message: message['notification']['body'], sender: "server",)

                (Map<String, dynamic> message) async {

                  MessageModel(message: message['notification']['body'],sender: "server", status: 'true');

                  return true;

          });
      }*/
    notifyListeners();
  }
      }

}

startlastFlow()async{

    await _rapidproservice.startRunflow(responseContactCreation.contactUuid);

}

startflow()async{

    var apiresponse = await _rapidproservice.getSingleContact(responseContactCreation.contactUuid);

    if(apiresponse.httpCode==200){
      _urn=apiresponse.data.results[0].urns.single;
      print("found contact successfully ${apiresponse.data.results[0].urns}");
      await _rapidproservice.startflow("e13441e4-b487-47db-b456-09a228968950", "${apiresponse.data.results[0].urns.single}",);
    }


}



    getfirebaseInitialmessage(){


      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) async {
            assert(message != null);
            print("the message is ${message!.data["message"]}");

      });
    }





  //on app notification
  getfirebase(){
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage){

      print("the message is ${remotemessage.data["message"]}");

      RemoteNotification? remoteNotification = remotemessage.notification;
      AndroidNotification? androidNotification = remotemessage.notification?.android;

      if(remoteNotification!=null && androidNotification!=null){
        flutterLocalNotificationsPlugin.show(remoteNotification.hashCode, remoteNotification.title, remoteNotification.body, NotificationDetails(

            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            )
        ));
      }
    });
  }
  // app background notification
  getfirebaseonApp(BuildContext context){

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage){
      RemoteNotification? remoteNotification = remotemessage.notification;
      AndroidNotification? androidNotification = remotemessage.notification?.android;

      if(remoteNotification!=null && androidNotification!=null){

        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text("${remoteNotification.title}"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${remoteNotification.body}"),
                ],
              ),
            ),
          );
        });

        flutterLocalNotificationsPlugin.show(remoteNotification.hashCode, remoteNotification.title, remoteNotification.body, NotificationDetails(

            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            )
        ));
      }
    });

  }
  sendmessage()async{

    await _rapidproservice.sendMessage(message: "Yes", onSuccess: (value){

      print("this response message $value");

    }, onError:(error){
      print("this is error message $error");
    },urn: _urn,fcmToken: _token);
  }
}