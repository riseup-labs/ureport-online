
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:ureport_ecaro/all-screens/home/chat/model/messagehandler.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import '../../../main.dart';
import 'Chat.dart';
import 'message-handler.dart';
import 'model/golbakey.dart';
import 'model/rapidpro-response-data.dart';
import 'model/response-local-chat-parsing.dart';
import 'notification-service.dart';

class ChatController extends ChangeNotifier{

  
  List<String>quicktype=[];
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  var _spservice = locator<SPUtil>();
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  List<MessageModel> messagearray =[];
   List<MessageModel> revlist=[];
   List<MessageModelLocal> localmessage=[];


   List<MessageModelLocal> ordered=[];
   List<MessageThread>messageThread=[];
   List<dynamic>quicktypedata=[];
  var filtermessage;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String messagestatus="sending";

  late ResponseContactCreation responseContactCreation;
  var _urn="";
  String _token ="";


  bool _selectall=false;


  bool get selectall => _selectall;

  set selectall(bool value) {
    _selectall = value;
    notifyListeners();
  }

  List<int>individualselect=[];
  List<MessageModelLocal>selectedMessage=[];


  deleteorginalMessage(){

    for(int i = 0;i<individualselect.length;i++){

      MessageModelLocal local = MessageModelLocal(
          message: "This Message was Deleted",
          sender: localmessage[individualselect[i]].sender,
          status: localmessage[individualselect[i]].status,
          quicktypest: "",
          time: localmessage[individualselect[i]].time);

      updateSingleMessage(localmessage[individualselect[i]].time,"This Message was Deleted");
      localmessage[individualselect[i]]= local;
      print("individula select is .................${individualselect[i]}");

    }
    individualselect.clear();
    selectedMessage.clear();
    selectall=false;
    notifyListeners();
  }


  addSelectionMessage(MessageModelLocal msg){
    selectedMessage.add(msg);
    notifyListeners();
  }

  deleteSelectionMessage(MessageModelLocal msg){
    selectedMessage.remove(msg);
    notifyListeners();
  }



  sellectAllItems(){
    print("total item is.................${localmessage.length}");
    for(int i =0;i<=localmessage.length;i++){
      individualselect.add(i);
    }
    notifyListeners();
  }

  addselectionitems(int index,){

    individualselect.add(index);

    notifyListeners();
  }
  removeIndex(int index,){

    individualselect.remove(index,);

    notifyListeners();
  }

  getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
    print("this is firebase fcm token ==  ${_token}");
  }

  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  addMessage(MessageModel messageModel)async{
    messagearray.add(messageModel);
    filtermessage=messagearray.toSet().toList();
    revlist = filtermessage.reversed.toList();
   await _databaseHelper.insertConversation(messagearray).then((value) async{

     await _databaseHelper.getConversation().then((valuereal) {
       ordered.addAll(valuereal);
      localmessage=ordered.reversed.toList();

      List<dynamic>quicktypedata = json.decode(localmessage[0].quicktypest.toString());
       print("...................getconversation called 2 $quicktypedata");



      /* for(int i =0;i<localmessage.length;i++){

         List<dynamic>quicktypelist=[];
         if(localmessage[i].quicktypest!=null){
           quicktypelist= json.decode(localmessage[i].quicktypest.toString());
           print("quick type list is ${quicktypelist}");

           var message = MessageThread(message: localmessage[i].message, sender: localmessage[i].sender,
               status: localmessage[i].status, quicktypest: quicktypelist, time: localmessage[i].time);
           messageThread.add(message);
         }
       }
*/

     });

   });

    notifyListeners();
  }

  List<dynamic>quicdata(String ss){

    List<dynamic>data=[];
    if(ss!="null" && ss.isNotEmpty && ss!=""){
      data = json.decode(ss);
      print("the length is ${data.length}");
      return data;
    }else {
      print("the length is ${data.length}");
      return data;
    }
  }


  deleteSingleMessage(time)async{

    print("message time $time");
    //localmessage.remove(item);
    await _databaseHelper.deleteSingelMessage(time);
  }

  updateSingleMessage(time,msg)async{

    print("message time $time");
    //localmessage.remove(item);
    await _databaseHelper.updateSingleMessage(time,msg);
  }

  delteAllMessage( )async{

    await _databaseHelper.deleteConversation();
    ordered.clear();
    localmessage.clear();
    notifyListeners();

  }



  deleteMessageAfterFiveDays()async{
    await _databaseHelper.deleteConversation();
    print("all message deleted.....................");
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
           //sendmessage("join");
         }else{
           sendmessage("covid");
         }
      }

    }

  }


  deletemsgAfterfiveDays()async{
    await _databaseHelper.getConversation().then((valuereal) {
      ordered.addAll(valuereal);

      //get curreent date
      DateTime now = DateTime.now();
      var earler = now.subtract(const Duration(seconds: 15));
      String olderdate = DateFormat('kk:mm:ss \n EEE d MMM').format(earler);
      //compare c_date with valuereal.date
      valuereal.forEach((element) async{
        if(earler.isBefore(DateTime.parse(element.time))){
          await _databaseHelper.deleteSingelMessage(element.time);
        }
      });
      //if(return 5 days) delete single row where date = valuereal.date
      notifyListeners();
    });

      }

  //on app notification
  getfirebase(){
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage){

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
      List<dynamic> quicktypest;
      if(remotemessage.data["quick_replies"]!=null){
         quicktypest = json.decode(remotemessage.data["quick_replies"]);
      }else{
        quicktypest=[""];
      }
      var serverMessage=MessageModel(sender: 'server',
          message: remotemessage.data["message"],
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);

     const String lastmessage ="You have finished your registration. We are glad to have you with us. Soon you will receive surveys on themes that you care about!";
     const String lastmessgetwo="You are already registered. Please wait for your first survey.";
     const String remove_Contact="You are unregistered to UReport. It's sad to see you go. You can come back at anytime by sending the word JOIN.";
     const String remove_Contact2="You have finished your registration. We are glad to have you with us. Soon you will receive surveys on themes that you care about!";
      if(serverMessage.message== lastmessage || serverMessage.message== lastmessgetwo){
        _spservice.setValue(SPUtil.REGISTRATION_COMPLETE, "YES");
      }

      if(serverMessage.message==remove_Contact || serverMessage.message==remove_Contact2){
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

  loaddefaultmessage()async{
    ordered.clear();
    localmessage.clear();
    await _databaseHelper.getConversation().then((valuereal) {
      ordered.addAll(valuereal);
      localmessage=ordered.reversed.toList();
      print("load message called again-------- ${localmessage.length}");
      notifyListeners();

    });
  }

  sendkeyword(String keyword){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    MessageModel messageModel = MessageModel(
      message: keyword,
      sender: "user",
      status: "Sending...",
      quicktypest: [""],
      time: formattedDate
    );

    addMessage(messageModel);
    sendmessage(keyword);
    messageModel.status=messagestatus;
    notifyListeners();

  }

  sendmessage(String message)async{
    String urn = _spservice.getValue(SPUtil.CONTACT_URN);

    await _rapidproservice.sendMessage(message: message, onSuccess: (value){

      print("this response message $value");
      messagestatus="Sent";

    }, onError:(error){
      print("this is error message $error");
      messagestatus="failed";
    },urn: urn,fcmToken: _token);

  }




 getfirebaseInitialmessage(){
    FirebaseMessaging.instance
        .getInitialMessage().then((RemoteMessage? remotemessage) {

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
      List<dynamic> quicktypest;
      if(remotemessage!.data["quick_replies"]!=null){
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      }else{
        quicktypest=[""];
      }
      print("the notification message is ${remotemessage.notification!.body}");
      var notificationmessage_terminatestate = MessageModel(sender: 'server',
          message: remotemessage.notification!.body,
          status: "received",
          quicktypest: quicktypest,time:formattedDate);
      addMessage(notificationmessage_terminatestate);
      //FirebaseNotificationService.display(remotemessage);


    });
  }


// app background notification
 getfirebaseonApp(){

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage){

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
      List<dynamic> quicktypest;
      if(remotemessage.data["quick_replies"]!=null){
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      }else{
        quicktypest=[""];
      }
      print("the notification message is ${remotemessage.notification!.body}");
      var notificationmessage = MessageModel(
          sender: 'server',
          message: remotemessage.notification!.body,
          status: "received",
          quicktypest: quicktypest,
          time:formattedDate);
      addMessage(notificationmessage);
     // FirebaseNotificationService.display(remotemessage);



    /*  if(remoteNotification!=null && androidNotification!=null){






        flutterLocalNotificationsPlugin.show(remoteNotification.hashCode,
            remoteNotification.title, remoteNotification.body, NotificationDetails(

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





}