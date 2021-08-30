
import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import '../../../main.dart';
import 'model/rapidpro-response-data.dart';

class ChatController extends ChangeNotifier{

  
  List<String>quicktype=[];
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  var _spservice = locator<SPUtil>();
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




  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

      String _urn =_spservice.getValue(SPUtil.CONTACT_URN);
      if(_urn==null){
        String contact_urn = getRandomString(15);
        var apiResponse = await _rapidproservice.createContact(contact_urn, _token,"Unknown",onSuccess:(uuid){
          contatct=uuid;

        } );
        // getfirebase();
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          _spservice.setValue(SPUtil.CONTACT_URN, contact_urn);
          sendmessage("join");

          notifyListeners();
        }

      }else{

        String registrationstaus = _spservice.getValue(SPUtil.REGISTRATION_COMPLETE);
         if(registrationstaus==null|| registrationstaus==""){
           sendmessage("join");
         }else{
           sendmessage("covid");
         }
      }

    }

  }


  //on app notification
  getfirebase(){
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage){

      List<dynamic> quicktypest;
      if(remotemessage.data["quick_replies"]!=null){
         quicktypest = json.decode(remotemessage.data["quick_replies"]);
      }else{
        quicktypest=[""];
      }
      var serverMessage=MessageModel(sender: 'server',message: remotemessage.data["message"],status: "received",quicktypest: quicktypest);

     const String lastmessage ="You have finished your registration. We are glad to have you with us. Soon you will receive surveys on themes that you care about!";
     const String lastmessgetwo="You are already registered. Please wait for your first survey.";
     const String remove_Contact="You are unregistered to UReport. It's sad to see you go. You can come back at anytime by sending the word JOIN.";
      if(serverMessage.message== lastmessage || serverMessage.message== lastmessgetwo){
        _spservice.setValue(SPUtil.REGISTRATION_COMPLETE, "YES");
      }

      if(serverMessage.message==remove_Contact){
        _spservice.setValue(SPUtil.REGISTRATION_COMPLETE, "");
      }
      addMessage(serverMessage);










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
    String urn = _spservice.getValue(SPUtil.CONTACT_URN);

    await _rapidproservice.sendMessage(message: message, onSuccess: (value){

      print("this response message $value");
      messagestatus="Sent";

    }, onError:(error){
      print("this is error message $error");
      messagestatus="failed";
    },urn: urn,fcmToken: _token);

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
/* getfirebaseonApp(){

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage){



      RemoteNotification? remoteNotification = remotemessage.notification;
      AndroidNotification? androidNotification = remotemessage.notification?.android;

      if(remoteNotification!=null && androidNotification!=null){

       *//* showDialog(context: context, builder: (_){
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
        });*//*

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

  }*/

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