import 'package:flutter/material.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';

import 'ChatAvatar.dart';


class ChatBubble extends StatelessWidget {
  final MessageModel message;
  ChatBubble(this.message);

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: message.sender == 'server'
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 10,),
        message.sender == "server" ? ChatAvatar("assets/images/ic_ureport_box.png") : Container(),
        SizedBox(width: 5,),
        Expanded(
          child: Column(
           crossAxisAlignment: message.sender == 'server'?CrossAxisAlignment.start:CrossAxisAlignment.end,
            children: [
              message.sender == 'server' ?
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 15),
                    child: Text(message.message,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold),textAlign: TextAlign.left,),
                    decoration: BoxDecoration(
                      color:Color(0xffF5FCFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),

                ],
              ):
              Container(
                padding: EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 15),
                decoration: BoxDecoration(
                  color:  Color(0xff41B6E6),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child:Text(message.message,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold),textAlign: TextAlign.right,),
              ),

             /* Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: message.sender == 'server'
                      ? Color(0xffF5FCFF)
                      : Color(0xff41B6E6),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: message.sender == 'server'?
                Text(message.message,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold),textAlign: TextAlign.left,):
                Text(message.message,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold),textAlign: TextAlign.right,),
              ),*/
              message.sender == 'user'
                  ? Text(
                      message.status != "Sent" ? "Sending.." : "Sent",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  : Container(),

              SizedBox(height: 10,)
            ],
          ),
        ),
        message.sender == "server" ? Container() : ChatAvatar("assets/images/ic_user_box.png"),

      ],
    );
  }
}
