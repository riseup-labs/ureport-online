
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';

import '../../../main.dart';
import 'model/rapidpro-response-data.dart';

class ChatController extends ChangeNotifier{

  
  List<String>quicktype=[];

  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  List<MessageModel> messagearray =[];
  var revlist;
  var filtermessage;

  String messagestatus="sending";

  late ResponseContactCreation responseContactCreation;
  var _urn="";
  String _token ="";
  getToken() async {

    _token = (await FirebaseMessaging.instance.getToken())!;
    print("this is firebase fcm token ==  ${_token}");
  }

  addMessage(value){

    messagearray.add(value);
    filtermessage=messagearray.toSet().toList();
    revlist = filtermessage.reversed.toList();
    notifyListeners();
  }

  createContatct() async {
    await getToken();
    if(_token.isNotEmpty){
      print("this is firebase fcm token ==  ${_token}");
      var apiResponse = await _rapidproservice.createContact(_token, _token,"Unknown",onSuccess:(uuid){
        contatct=uuid;
        print("new contact is created ${contatct}");
      } );
      // getfirebase();
      if (apiResponse.httpCode == 200) {
        responseContactCreation = apiResponse.data;
        sendmessage("join");
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


  //on app notification
  getfirebase(){
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage){


      List<dynamic> quicktypest;
      if(remotemessage.data["quick_replies"]!=null){
         quicktypest = json.decode(remotemessage.data["quick_replies"]);
         print("quick type length---------${quicktypest.length}");
      }else{
        quicktypest=[""];
        print("quick type length---------${quicktypest.length}");
      }

      var serverMessage=MessageModel(sender: 'server',message: remotemessage.data["message"],status: "received",quicktypest: quicktypest);

      addMessage(serverMessage);


      for(int i =0;i<quicktypest.length;i++){
        print("quick type data --------------------------====0---------------- ${quicktypest[i]}");
      }










     /* RemoteNotification? remoteNotification = remotemessage.notification;
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
      }*/
    });
  }


  sendmessage(message)async{

    await _rapidproservice.sendMessage(message: message, onSuccess: (value){

      print("this response message $value");
      messagestatus="Sent";

    }, onError:(error){
      print("this is error message $error");
      messagestatus="failed";
    },urn: _token,fcmToken: _token);

  }

















/* getfirebaseInitialmessage(){


    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      assert(message != null);
      print("the message is ${message!.data["message"]}");
      MessageModel(sender: 'server',message: message.data["message"],status: "received");

    });
  }*/


// app background notification
 getfirebaseonApp(){

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage){



      RemoteNotification? remoteNotification = remotemessage.notification;
      AndroidNotification? androidNotification = remotemessage.notification?.android;

      if(remoteNotification!=null && androidNotification!=null){

       /* showDialog(context: context, builder: (_){
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
        });*/

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

/*startlastFlow()async{
    await _rapidproservice.startRunflow(responseContactCreation.contactUuid);
  }

  startflow()async{

    var apiresponse = await _rapidproservice.getSingleContact(responseContactCreation.contactUuid);

    if(apiresponse.httpCode==200){
      _urn=apiresponse.data.results[0].urns.single;
      print("found contact successfully ${apiresponse.data.results[0].urns}");

      var validator= apiresponse.data;
      validator.results[0].groups.forEach((element)async {

        if(element['name']=='Registered'){

          return await _rapidproservice.startRunflow(responseContactCreation.contactUuid);
        }

      });

      await _rapidproservice.startflow("e13441e4-b487-47db-b456-09a228968950", "${apiresponse.data.results[0].urns.single}",);
    }


  }*/

}