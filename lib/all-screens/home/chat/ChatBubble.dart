import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';

import 'ChatAvatar.dart';
import 'model/response-local-chat-parsing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChatBubble extends StatefulWidget {
 // final MessageModel message;
  final MessageModelLocal localmessage;
  ChatBubble(this.localmessage);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {



  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;


    return Consumer<ChatController>(
      builder: (context,provider,chidl){
        return GestureDetector(
          onLongPress: (){
            provider.selectall=true;
           showDialog(context: context, builder: (_){
             return Center(
               child: Container(
                 margin: EdgeInsets.only(left: 15,right: 15),

                 width: double.infinity,
                 height: 120,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(10)),
                   color: Colors.white

                 ),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

                     Text(AppLocalizations.of(context)!.delete_message,style: TextStyle(color: Colors.red,fontSize: 17),),
                     SizedBox(height: 8,),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         GestureDetector(
                           onTap: (){
                             Navigator.pop(context);
                           },
                           child: Container(
                             height: 40,
                             width: 120,
                             padding: EdgeInsets.all(10),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(15)),
                               color: Colors.blue
                             ),
                             child: Center(child: Text("Yes",style:TextStyle(color: Colors.white),),),
                           ),
                         ),
                         SizedBox(width: 10,),
                         Container(
                           height: 40,
                           width: 120,
                           padding: EdgeInsets.all(10),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(15)),
                             border: Border.all(color: Colors.grey)
                           ),
                           child: Center(child: Text("No"),),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             );
           });
           print("loon press activated............${widget.localmessage.message}");
          },
          child: Row(
            mainAxisAlignment: widget.localmessage.sender == 'server'
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10,),
              widget.localmessage.sender == "server" ? ChatAvatar("assets/images/v2_ic_avatar_global.png",false) : Container(),
              SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.localmessage.sender == 'server'?CrossAxisAlignment.start:CrossAxisAlignment.end,
                  children: [
                    widget.localmessage.sender == 'server' ?
                    Container(
                      padding: EdgeInsets.only(top: 15,bottom: 15,right: 15,left: 15),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color:Color(0xffF5FCFF),
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child:  Text(widget.localmessage.message!,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.left,),
                    ):
                    Container(
                      padding: EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 15),
                      decoration: BoxDecoration(
                        color:  Color(0xff41B6E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Text(widget.localmessage.message!,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.right,),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.localmessage.sender=="server" && provider.quicdata(widget.localmessage.quicktypest.toString()).length>1 && widget.localmessage.quicktypest.isNotEmpty?
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder:(context,index){
                        return Column(
                          children: [
                            GestureDetector(
                              onTap:(){
                                MessageModel messageModel = MessageModel(
                                  message: provider.quicdata(widget.localmessage.quicktypest.toString())[index],
                                  sender: "user",
                                  status: "Sending...",
                                  quicktypest: [""],
                                  time: ""
                                );
                                provider.addMessage(messageModel);
                                // provider.sendmessage(provider.quicdata(widget.localmessage.quicktypest.toString())[index].toString());
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

                                child: Center(child: Text("${provider.quicdata(widget.localmessage.quicktypest.toString())[index]}",style: TextStyle(color: Colors.black,fontSize:15,fontWeight: FontWeight.w400),)),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      } ,
                      itemCount: provider.quicdata(widget.localmessage.quicktypest.toString()).length,
                    ):
                    Container(),
                    widget.localmessage.sender == 'user'
                        ? Text(
                      widget.localmessage.status != "Sent" ? "Sending.." : "Sent",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                        : Container(),

                    SizedBox(height: 10,)
                  ],
                ),
              ),
              widget.localmessage.sender == "server" ? Container() : ChatAvatar("assets/images/ic_user_box.png",true),

            ],
          ),
        );
      },

    );
  }
}
