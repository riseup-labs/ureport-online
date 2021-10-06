import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:ureport_ecaro/all-screens/home/chat/model/messagehandler.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/apicall_responsedata/response_contact_creation.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/network_operation/rapidpro_service.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import '../../../main.dart';
import 'Chat.dart';
import 'message-handler.dart';
import 'model/golbakey.dart';
import 'model/rapidpro-response-data.dart';
import 'model/response-local-chat-parsing.dart';
import 'notification-service.dart';

class ChatController extends ChangeNotifier {
  List<String> quicktype = [];
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  var _spservice = locator<SPUtil>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  List<MessageModel> messagearray = [];
  List<MessageModel> revlist = [];
  List<MessageModelLocal> localmessage = [];

  List<MessageModelLocal> ordered = [];
  List<MessageThread> messageThread = [];
  List<dynamic> quicktypedata = [];
  var filtermessage;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String messagestatus = "sending";

  late ResponseContactCreation responseContactCreation;
  var _urn = "";
  String _token = "";

  bool isLoaded = true;

  bool _selectall = false;
  bool _allitemselected = false;
  bool _isMessageCome = false;

  bool get isMessageCome => _isMessageCome;

  set isMessageCome(bool value) {
    _isMessageCome = value;
    notifyListeners();
  }

  bool get allitemselected => _allitemselected;

  set allitemselected(bool value) {
    _allitemselected = value;
    notifyListeners();
  }

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  bool get selectall => _selectall;

  set selectall(bool value) {
    _selectall = value;
    notifyListeners();
  }

  List<int> individualselect = [];
  List<MessageModelLocal> selectedMessage = [];
  List<MessageModelLocal> delectionmessage = [];

  //done

  deleteMessage() async {
    //localmessage[individualselect[i]]= local;

    for (int i = 0; i < individualselect.length; i++) {
      MessageModelLocal msgl = MessageModelLocal(
          message: "This Message was Deleted",
          sender: localmessage[individualselect[i]].sender,
          status: localmessage[individualselect[i]].status,
          quicktypest: "",
          time: localmessage[individualselect[i]].time);
      localmessage[individualselect[i]] = msgl;

      // print("the message time is------------ ${msgl.time}");

      await _databaseHelper.updateSingleMessage(msgl);
    }
    selectall = false;
    notifyListeners();
  }

  deleteAllMessage() {}

  selectAllMessage() {
    individualselect.clear();
    selectedMessage.clear();
    List<MessageModelLocal> willReplacelist = [];

    //final index = localmessage.indexWhere((element) => element.message!="This Message was Deleted");
    willReplacelist.addAll(localmessage
        .where((element) => element.message != "This Message was Deleted"));

    List<MessageModelLocal> list = [];
    for (int i = 0; i < localmessage.length; i++) {
      if (localmessage[i].message != "This Message was Deleted") {
        individualselect.add(i);
      }
      /* MessageModelLocal mscl =MessageModelLocal(message: "This Message was Deleted",
          sender: willReplacelist[i].sender, status: willReplacelist[i].status, quicktypest: "", time: willReplacelist[i].time);

      list.add(mscl);*/
    }

    if (list.length > 0) selectedMessage.addAll(list);
    //print("select message length is ............${selectedMessage.length}");
    notifyListeners();
  }

  addSelectionMessage(MessageModelLocal msg) {
    /*   MessageModelLocal msgl   = MessageModelLocal(message: "This Message was Deleted", sender: msg.sender,
        status: msg.status, quicktypest: "", time: msg.time);*/
    selectedMessage.add(msg);
    notifyListeners();
  }

  deleteSelectionMessage(MessageModelLocal msg) {
    /* MessageModelLocal msgl   = MessageModelLocal(message: "This Message was Deleted", sender: msg.sender,
        status: msg.status, quicktypest: "", time: msg.time);*/
    selectedMessage.remove(msg);
    //print("after remove/deselect total selected length is -----${selectedMessage.length}");
    notifyListeners();
  }

  replaceQuickReplaydata(int index, data) async {
    // print("the data is ..======================================================================.........${data}");
    List<dynamic> repdata = [];
    repdata.add(data);
    localmessage[index].quicktypest = '["$data"]';
    // print("the data is ..======================================================================.........${ jsonEncode(repdata)}");

    await _databaseHelper
        .updateQuicktypeMessage(localmessage[index].time, repdata)
        .then((value) async {
      await loaddefaultmessage();
      notifyListeners();
    });
  }

  addQuickType() async {
    List<dynamic> repdata = [];
    var data = RemoteConfigData.getDefaultAction();
    // repdata.add(data);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

    MessageModel messageModel = MessageModel(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: data,
        time: formattedDate);
    MessageModelLocal messageModelLocal = MessageModelLocal(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: jsonEncode(data),
        time: formattedDate);

    if (localmessage.length > 0) {
      localmessage[0] = messageModelLocal;
    } else {
      localmessage.add(messageModelLocal);
    }
    notifyListeners();
  }

  addQuickTypeCaseManagement() async {
    List<dynamic> repdata = [];
    var data = RemoteConfigData.getOneToOneAction();
    // repdata.add(data);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

    MessageModel messageModel = MessageModel(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: data,
        time: formattedDate);
    MessageModelLocal messageModelLocal = MessageModelLocal(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: jsonEncode(data),
        time: formattedDate);

    if (localmessage.length > 0) {
      localmessage[0] = messageModelLocal;
    } else {
      localmessage.add(messageModelLocal);
    }
  }

  addselectionitems(
    int index,
  ) {
    individualselect.add(index);

    notifyListeners();
  }

  removeIndex(
    int index,
  ) {
    individualselect.remove(
      index,
    );

    notifyListeners();
  }

  getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
    // print("this is firebase fcm token ==  ${_token}");
  }

  bool firstmessageStatus() {
    String firstvalue = _spservice.getValue(SPUtil.FIRSTMESSAGE);
    if (firstvalue == "SENT") {
      return true;
    } else
      return false;
  }

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  addMessage(MessageModel messageModel) async {
    _spservice.setValue(SPUtil.FIRSTMESSAGE, "SENT");
    messagearray.clear();
    ordered.clear();

    messagearray.add(messageModel);
    await _databaseHelper.insertConversation(messagearray).then((value) async {
      await _databaseHelper.getConversation().then((valuereal) {
        ordered.addAll(valuereal);
        localmessage = ordered.reversed.toList();
      });
    });

    notifyListeners();
  }

  List<dynamic> quicdata(String ss) {
    List<dynamic> data = [];

    if (ss != "null" && ss.isNotEmpty && ss != "" && !ss.isEmpty) {
      data = json.decode(ss);

      return data;
    } else {
      return data;
    }
  }

  deleteSingleMessage(time) async {
    print("message time $time");
    //localmessage.remove(item);
    await _databaseHelper.deleteSingelMessage(time);
  }

  delteAllMessage() async {
    await _databaseHelper.deleteConversation();
    ordered.clear();
    localmessage.clear();
    notifyListeners();
  }

  createContatct() async {
    _spservice.setValue(SPUtil.USER_ROLE, "regular");
    print("Call frem : Create contact called");
    await getToken();
    if (_token.isNotEmpty) {
      String _urn = _spservice.getValue(SPUtil.CONTACT_URN);
      if (_urn == null) {
        String contact_urn = getRandomString(15);
        var apiResponse = await _rapidproservice.createContact(
            contact_urn, _token, "Regular Use", onSuccess: (uuid) {
          contatct = uuid;
        });
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          _spservice.setValue(SPUtil.CONTACT_URN, contact_urn);
          if (_spservice.getValue(SPUtil.REG_CALLED) == null) {
            sendmessage("join", "createContatct if");
            _spservice.setValue(SPUtil.REG_CALLED, "true");
          }
        }
      } else if (_urn != null) {
        if (_spservice.getValue(SPUtil.REG_CALLED) == null) {
          sendmessage("join", "createContatct if");
          _spservice.setValue(SPUtil.REG_CALLED, "true");
        }
      }
    }
  }

  createIndividualCaseManagement(messagekeyword) async {
    await getToken();
    if (_token.isNotEmpty) {
      String _urn = _spservice.getValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE);
      //print("l============================== casemanegement ${_urn}");
      if (_urn == null) {
        String contact_urn = getRandomString(15);
        // print("the new Contact urn for the individual casemanegement ${contact_urn}");
        var apiResponse = await _rapidproservice
            .createContact(contact_urn, _token, "Unknown", onSuccess: (uuid) {
          contatct = uuid;
        });
        // getfirebase();
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          _spservice.setValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE, contact_urn);

          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

          MessageModel messageModel = MessageModel(
              message: messagekeyword,
              sender: "user",
              status: "Sending...",
              quicktypest: [""],
              time: formattedDate);
          // print("the message keyword is ..............${messagekeyword}");
          // addMessage(messageModel);
          List<MessageModel> list = [];
          list.add(messageModel);
          _databaseHelper.insertConversation(list);
          sendmessage(messagekeyword, "createIndividualCaseManagement");
          messageModel.status = messagestatus;

          notifyListeners();
        }
      } else if (_urn != null) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

        MessageModel messageModel = MessageModel(
            message: messagekeyword,
            sender: "user",
            status: "Sending...",
            quicktypest: [""],
            time: formattedDate);
        // addMessage(messageModel);
        List<MessageModel> list = [];
        list.add(messageModel);
        _databaseHelper.insertConversation(list);
        sendmessage(messagekeyword, "createIndividualCaseManagement");
        messageModel.status = messagestatus;

        notifyListeners();
      }
    }
  }

  List<String> detectedlink = [];

  deletemsgAfterfiveDays() async {
    if (_spservice.getValue(SPUtil.DELETE5DAYS) == "true") {
      await _databaseHelper.getConversation().then((valuereal) {
        //get curreent date
        DateTime now = DateTime.now();
        //compare c_date with valuereal.date
        valuereal.forEach((element) async {
          DateTime valuetime =
              new DateFormat('dd-MM-yyyy hh:mm:ss a').parse(element.time);
          Duration sincetime = now.difference(valuetime);

          if (sincetime.inSeconds >= 60) {
            await deleteSingleMessage(element.time);
            notifyListeners();
          }
        });
      });
    }
  }

  List<String> getLinkClickable(String singleMessage) {
    List<String> stringlist = singleMessage.split(" ");

    List<String> dummy = [];

    TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(singleMessage);

    matches.forEach((element) {
      detectedlink.add(singleMessage.substring(element.start, element.end));
    });

    return stringlist;
  }

  //on app notification
  getfirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

      print("remoteMessage:  ${remotemessage.data}");
      ClickSound.soundMsgReceived();

      List<dynamic> quicktypest;
      if (remotemessage.data["quick_replies"] != null) {
        //print("the incomeing quick tyupe data is........${remotemessage.data["quick_replies"]}");
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      } else {
        quicktypest = [""];
      }

      var serverMessage = MessageModel(
          sender: 'server',
          message: remotemessage.data["message"],
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);

      const String lastmessage =
          "You have finished your registration. We are glad to have you with us. Soon you will receive surveys on themes that you care about!";
      const String lastmessgetwo =
          "You are already registered. Please wait for your first survey.";
      const String remove_Contact =
          "You are unregistered to UReport. It's sad to see you go. You can come back at anytime by sending the word JOIN.";
      const String remove_Contact2 =
          "You have finished your registration. We are glad to have you with us. Soon you will receive surveys on themes that you care about!";
      if (serverMessage.message == lastmessage ||
          serverMessage.message == lastmessgetwo) {
        _spservice.setValue(SPUtil.REGISTRATION_COMPLETE, "YES");
      }

      if (serverMessage.message == remove_Contact ||
          serverMessage.message == remove_Contact2) {
        _spservice.setValue(SPUtil.REGISTRATION_COMPLETE, "");
      }
      addMessage(serverMessage);
      isMessageCome = false;
    });
  }

  loaddefaultmessage() async {
    ordered.clear();
    localmessage.clear();
    await _databaseHelper.getConversation().then((valuereal) {
      ordered.addAll(valuereal);
      localmessage = ordered.reversed.toList();
      notifyListeners();
    });
  }

  sendmessage(String message, String from) async {
    print("Call frem : $from");

    isMessageCome = true;
    String urn = "";
    String userRole = _spservice.getValue(SPUtil.USER_ROLE);

    print("User role : $userRole");

    if (userRole == "regular") {
      urn = _spservice.getValue(SPUtil.CONTACT_URN);
    } else {
      urn = _spservice.getValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE);
    }

    await _rapidproservice.sendMessage(
        message: message,
        onSuccess: (value) {
          // print("this response message $value");
          messagestatus = "Sent";
        },
        onError: (error) {
          //  print("this is error message $error");
          messagestatus = "failed";
        },
        urn: urn,
        fcmToken: _token);
  }

  getfirebaseInitialmessage() {
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
        //print("the notification message is ${remotemessage.notification!.body}");
        var notificationmessage_terminatestate = MessageModel(
            sender: 'server',
            message: remotemessage.notification!.body,
            status: "received",
            quicktypest: quicktypest,
            time: formattedDate);
        addMessage(notificationmessage_terminatestate);
        FirebaseNotificationService.display(remotemessage);
      }
    });
  }

// app background notification
  getfirebaseonApp(context) {
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
      addMessage(notificationmessage);
      FirebaseNotificationService.display(remotemessage);
      NavUtils.pushReplacement(context, NavigationScreen(1));
    });
  }
}
