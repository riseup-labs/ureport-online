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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(

              width: screen.width/2,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: message.sender == 'server'
                    ? Color(0xffF5FCFF)
                    : Color(0xff41B6E6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: message.sender == 'server'? Text(message.message,style: TextStyle(color: Colors.black)):
              Text(message.message,style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
            ),
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
        message.sender == "server" ? Container() : ChatAvatar("assets/images/ic_user_box.png"),
      ],
    );
  }
}
