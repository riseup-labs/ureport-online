import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ChatBubble.dart';
import 'chat-controller.dart';



class Chat extends StatelessWidget {


  final sendMessageKey = GlobalKey<FormState>();
  ScrollController _scrollController = new ScrollController();
  String message = "";
  bool serverStarted = false;
  bool flowStarted = false;



  @override
  Widget build(BuildContext context) {

    Provider.of<ChatController>(context,listen: false).createContatct();
    Provider.of<ChatController>(context,listen: false).getfirebase();
    Provider.of<ChatController>(context,listen: false).messagearray.clear();



    return Consumer<ChatController>(
      builder: (context,provider,child){
        return  Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.revlist?.length??0,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatBubble(provider.revlist[index]);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      width: 350,
                      padding: EdgeInsets.only(left: 5,right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: sendMessage(context,provider),
                    )
                  ],
                ),
              ),
             /* sendMessage(context),*/
            ],
          ),
        );
      },
    );
  }
  Widget sendMessage(context,provider) {
    return Form(
      key: sendMessageKey,
      child: Row(

        children: [
          SizedBox(width: 10,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(

              ),

              child: TextFormField(
                onChanged: (String value) {
                  message = value;
                },

                decoration: InputDecoration.collapsed(
                  hintText: "${AppLocalizations.of(context)!.enter_message}",
                ),
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Image.asset("assets/images/ic_sand.png"),

            onPressed: () {
              sendMessageKey.currentState!.save();
              if (message == "") return;
              MessageModel messageModel = MessageModel(
                message: message,
                sender: "user",
                status: "Sending...",
                quicktypest: [""],
              );
              provider.addMessage(messageModel);
              provider.sendmessage(message);
              messageModel.status=provider.messagestatus;
              sendMessageKey.currentState!.reset();


            },
          )
        ],
      ),
    );
  }
}
