import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ureport_ecaro/generic_model/return_obj.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';

import '../../main.dart';

class ProviderLoginController extends ChangeNotifier{

  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  late ResponseContactCreation responseContactCreation;
   String _token ="";
  getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
    //print("this is firebase fcm token ==  ${_token}");
  }

  createContatct() async {
     await getToken();
      if(_token.isNotEmpty){
        print("this is firebase fcm token ==  ${_token}");
         var apiResponse = await _rapidproservice.createContact("hossain.riseuplabs@gmail.com", _token,onSuccess:(uuid){
           contatct=uuid;
         } );
          // getfirebase();


        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          
          await _rapidproservice.runflow(responseContactCreation.contactUuid);
         /* await _rapidproservice.getFlowid(contatct);
          await _rapidproservice.sendMessage(message: "this hi from me", onSuccess: (response){

            print("thisis the value from send message ${response}");
            return;
          }, onError: (value){
            print("thisis the value from send message ${value}");
            return ;
          }, urn:"fcm:2d2adce0-d599-489c-80ab-891dc0c1ebf6",fcmToken: _token);
        } else {
          print("something went wrong");

        }*/
      }
    notifyListeners();
  }

}

  //on app notification
  getfirebase(){
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage){
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

    await _rapidproservice.sendMessage(message: "test message", onSuccess: (value){

      print("this response message $value");

    }, onError:(error){
      print("this is error message $error");
    },urn: "fcm:2d2adce0-d599-489c-80ab-891dc0c1ebf6",fcmToken: _token);
  }
}