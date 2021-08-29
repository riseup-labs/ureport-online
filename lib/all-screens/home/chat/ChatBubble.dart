import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';

import 'ChatAvatar.dart';


class ChatBubble extends StatelessWidget {
  final MessageModel message;
  ChatBubble(this.message);

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Consumer<ChatController>(
      builder: (context,provider,chidl){
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
                  Container(
                    padding: EdgeInsets.only(top: 15,bottom: 15,right: 15,left: 15),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color:Color(0xffF5FCFF),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child:  Text(message.message,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.left,),
                  ):
                  Container(
                    padding: EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 15),
                    decoration: BoxDecoration(
                      color:  Color(0xff41B6E6),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child:Text(message.message,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.right,),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  message.sender=="server" && message.quicktypest[0]!=""? ListView.builder(

                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder:(context,index){
                      return Column(
                        children: [
                          GestureDetector(
                            onTap:(){
                              MessageModel messageModel = MessageModel(
                                message: message.quicktypest[index].toString(),
                                sender: "user",
                                status: "Sending...",
                                quicktypest: [""],
                              );
                              provider.addMessage(messageModel);
                              provider.sendmessage(message.quicktypest[index].toString());
                              messageModel.status=provider.messagestatus;
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color:Colors.white,
                                  border:Border.all(color: Color(0xff41B6E6)),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),

                              child: Center(child: Text("${message.quicktypest[index]}",style: TextStyle(color: Colors.black,fontSize:15,fontWeight: FontWeight.w400),)),
                            ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      );
                    } ,
                    itemCount: message.quicktypest.length,
                  ):
                  Container(),


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
      },

    );
  }
}
