import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'ChatAvatar.dart';
import 'ChatBubble.dart';
import 'chat-controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'custom-dropdwon.dart';
import 'custom-popup-individual-case-management.dart';
import 'custom-popup-menu.dart';
import 'custom-popup-third.dart';



class Chat extends StatefulWidget {


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final sendMessageKey = GlobalKey<FormState>();

  ScrollController _scrollController = new ScrollController();

  String message = "";

  bool serverStarted = false;

  bool flowStarted = false;

  @override
  void initState() {
    Provider.of<ChatController>(context,listen: false).createContatct();
    Provider.of<ChatController>(context,listen: false).getfirebaseInitialmessage();
    Provider.of<ChatController>(context,listen: false).getfirebase();
    Provider.of<ChatController>(context,listen: false).getfirebaseonApp();
    Provider.of<ChatController>(context,listen: false).loaddefaultmessage();
    //  Provider.of<ChatController>(context,listen: false).getNotification(context);

    Provider.of<ChatController>(context,listen: false).deletemsgAfterfiveDays();
    super.initState();
  }

  @override
  void dispose() {

    Provider.of<ChatController>(context,listen: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context,provider,child){
        return  SafeArea(
          child: Scaffold(
           /* appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black, size: 10.0),
              elevation: 0.5,
              actions: [
                PopupMenuButton<String>(
                    onSelected: provider.sendkeyword,
                    itemBuilder: (BuildContext context){

                      return ApiConst.Choicekeyord.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice ,
                            child: Text("$choice",style: TextStyle(color: Colors.black),)
                        );

                      }).toList();

                })
              ],
            ),*/
            body: Container(
              color: Colors.white,
              child: Column(
                children: [

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [

                     Container(
                         margin: EdgeInsets.only(top: 15,left: 20),
                         child: CachedNetworkImage(
                           imageUrl: RemoteConfigData.getLargeIcon(),
                           height: 30,
                           width: 150,
                         )),
                     Spacer(),
                     Container(

                       padding: EdgeInsets.only(left:20,right: 20),
                       margin: EdgeInsets.only(top: 15),
                       child: CustomDropdownForth(
                         keyword: RemoteConfigData.getOneToOneAction(),
                         iconColor: Colors.white,
                         onChange: (index) {
                           print(index);
                         }, borderRadius: BorderRadius.all(Radius.circular(10)),
                       ),
                     ),

                     provider.selectall==true? GestureDetector(

                       onTap: (){
                        // provider.sellectAllItems();
                         if(provider.selectall==true){
                           provider.selectAllMessage();
                         }
                       },
                       child: Container(
                         margin: EdgeInsets.only(right: 15),
                         child:Text("Select All",style: TextStyle(color: Colors.blue,fontSize: 15),),
                       ),
                     )
                         :GestureDetector(

                       onTap: (){

                       },
                           child: Container(

                       padding: EdgeInsets.only(left:20,right: 20),
                       margin: EdgeInsets.only(top: 15),
                       child: CustomDropdownThird(
                        keyword: RemoteConfigData.getDefaultAction(),
                         iconColor: Colors.white,
                         onChange: (index) {
                           print(index);
                         }, borderRadius: BorderRadius.all(Radius.circular(10)),
                       ),
                     ),
                         ),
                   ],
                 ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      child:  provider.localmessage.length>0  ? ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.localmessage.length>0 ? provider.localmessage?.length:0,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return provider.selectall==true && provider.localmessage[index].message!="This Message was Deleted"?
                         //after selecting the item..........the view is as following................
                          GestureDetector(
                            onTap: (){
                              if(provider.individualselect.contains(index)){
                                provider.removeIndex(index,);
                                provider.deleteSelectionMessage(provider.localmessage[index]);

                              }else{
                                provider.addselectionitems(index,);
                                provider.addSelectionMessage(provider.localmessage[index]);

                              }
                            },
                            child: Row(
                              mainAxisAlignment: provider.localmessage[index].sender == 'server'
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    GestureDetector(

                                      onTap:(){
                                        if(provider.individualselect.contains(index)){
                                          provider.removeIndex(index,);
                                         provider.deleteSelectionMessage(provider.localmessage[index]);

                                        }else{
                                          provider.addselectionitems(index,);
                                          provider.addSelectionMessage(provider.localmessage[index]);

                                        }
                                      },
                                      child: provider.individualselect.contains(index) ?Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          border: Border.all(color: Colors.blue),
                                          color: Colors.blue,
                                        ),
                                      ):Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          border: Border.all(color: Colors.blue),

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                provider.localmessage[index].sender == "server" ? ChatAvatar("assets/images/ic_ureport_box.png") : Container(),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: provider.localmessage[index].sender == 'server'?CrossAxisAlignment.start:CrossAxisAlignment.end,
                                    children: [
                                      provider.localmessage[index].sender == 'server' ?
                                      Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5,right: 15,left: 15),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color:Color(0xffF5FCFF),
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child:  Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.left,),
                                      ):
                                      Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 15),
                                        decoration: BoxDecoration(
                                          color:  Color(0xff41B6E6),
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child:Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.right,),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      provider.localmessage[index].sender=="server" && provider.quicdata(provider.localmessage[index].quicktypest.toString()).length>1 && provider.localmessage[index].quicktypest.isNotEmpty?
                                      ListView.builder(

                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:(context,j){
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap:(){


                                                  DateTime now = DateTime.now();
                                                  String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
                                                  MessageModel messageModel = MessageModel(
                                                      message: provider.quicdata(provider.localmessage[index].quicktypest.toString())[j],
                                                      sender: "user",
                                                      status: "Sending...",
                                                      quicktypest: [""],
                                                      time: formattedDate
                                                  );
                                                  provider.addMessage(messageModel);
                                                  provider.sendmessage(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString());
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

                                                  child: Center(child: Text("${provider.quicdata(provider.localmessage[index].quicktypest.toString())[j]}",style: TextStyle(color: Colors.black,fontSize:15,fontWeight: FontWeight.w400),)),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                            ],
                                          );
                                        } ,
                                        itemCount: provider.quicdata(provider.localmessage[index].quicktypest.toString()).length,
                                      ):
                                      Container(),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                                provider.localmessage[index].sender == "server" ? Container() : ChatAvatar("assets/images/ic_user_box.png"),

                              ],
                            ),
                          ):


                              //before select the view is .............as following
                          GestureDetector(
                            onLongPress: (){
                              provider.selectall=true;
                              provider.individualselect.clear();
                              // provider.deleteSingleMessage(localmessage.time);


                            },
                            child: Row(
                              mainAxisAlignment: provider.localmessage[index].sender == 'server'
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                provider.localmessage[index].sender == "server" ? ChatAvatar("assets/images/ic_ureport_box.png") : Container(),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: provider.localmessage[index].sender == 'server'?CrossAxisAlignment.start:CrossAxisAlignment.end,
                                    children: [
                                      provider.localmessage[index].sender == 'server' ?

                                      Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5,right: 15,left: 15),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color:provider.localmessage[index].message=="This Message was Deleted"?Color(0xffCCCCCC): Color(0xffF5FCFF),
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: provider.localmessage[index].message=="This Message was Deleted" ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(provider.localmessage[index].message!,
                                              style: TextStyle(color: Colors.black,fontSize: 12,fontWeight:FontWeight.w400),
                                              textAlign: TextAlign.left,),
                                            SizedBox(width: 5,),
                                            Icon(Icons.not_interested_rounded,size: 12,color: Colors.black,),
                                          ],
                                        ):
                                        Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),
                                          textAlign: TextAlign.left,),


                                      ):
                                      Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 15),
                                        decoration: BoxDecoration(
                                          color:  provider.localmessage[index].message=="This Message was Deleted"?Color(0xffCCCCCC): Color(0xff41B6E6),
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: provider.localmessage[index].message=="This Message was Deleted" ?
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Icon(Icons.not_interested_rounded,size: 12,color: Colors.black,),
                                            SizedBox(width: 5,),

                                            Text(provider.localmessage[index].message!,
                                              style: TextStyle(color: Colors.black,fontSize: 12,fontWeight:FontWeight.w400),
                                              textAlign: TextAlign.left,),

                                          ],
                                        ):
                                        Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.w400),
                                          textAlign: TextAlign.left,),
                                      ),



                                      SizedBox(
                                        height: 10,
                                      ),
                                      provider.localmessage[index].sender=="server" && provider.quicdata(provider.localmessage[index].quicktypest.toString()).length>1 && provider.localmessage[index].quicktypest.isNotEmpty?
                                      ListView.builder(

                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:(context,j){
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap:(){
                                                  DateTime now = DateTime.now();
                                                  String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
                                                  MessageModel messageModel = MessageModel(
                                                      message: provider.quicdata(provider.localmessage[index].quicktypest.toString())[j],
                                                      sender: "user",
                                                      status: "Sending...",
                                                      quicktypest: [""],
                                                      time: formattedDate
                                                  );
                                                  provider.addMessage(messageModel);
                                                  provider.sendmessage(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString());
                                                  messageModel.status=provider.messagestatus;
                                                  provider.replaceQuickReplaydata(index,provider.quicdata(provider.localmessage[index].quicktypest.toString())[j]);

                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      color:Colors.white,
                                                      border:Border.all(color: Color(0xff41B6E6)),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),

                                                  child: Center(child: Text("${provider.quicdata(provider.localmessage[index].quicktypest.toString())[j]}",style: TextStyle(color: Colors.black,fontSize:15,fontWeight: FontWeight.w400),)),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                            ],
                                          );
                                        } ,
                                        itemCount: provider.quicdata(provider.localmessage[index].quicktypest.toString()).length,
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

                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                                provider.localmessage[index].sender == "server" ? Container() : ChatAvatar("assets/images/ic_user_box.png"),
                                SizedBox(width: 10,),

                              ],
                            ),
                          );
                        },
                      ):
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            provider.firstmessageStatus()==true? Container(
                              padding: EdgeInsets.only(left:12,right: 12,top: 5,bottom: 5),
                              decoration: BoxDecoration(
                                color: Color(0xffCCCCCC),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Icon(Icons.not_interested_rounded,size: 12,color: Colors.black,),
                                  SizedBox(width: 5,),

                                  Text("All Previous Message was deleted",
                                    style: TextStyle(color: Colors.black,fontSize: 12,fontWeight:FontWeight.w700),
                                    textAlign: TextAlign.left,),

                                ],
                              ) ,
                            ):SizedBox(),
                            SizedBox(height: 20,),
                          ],
                        ),
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
                    //donee

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),

                            ),
                            child: provider.selectall==true ?
                            Container(
                              height: 120,
                              width: double.infinity,

                              child: Row(

                                children: [
                                 GestureDetector(

                                     onTap: (){
                                       showDialog(context: context, builder: (_){

                                  return Dialog(

                                    child: Container(
                                      margin: EdgeInsets.only(left: 10,right: 10),

                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white

                                      ),
                                      child: Column(

                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5,),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Are You Sure?Do you want to delete this message? ",style:TextStyle(color:Colors.red,fontSize: 15)),

                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          GestureDetector(
                                              onTap:(){
                                                provider.deleteMessage();
                                                Navigator.pop(context);
                                              },
                                              child: Text("Delete",style: TextStyle(color: Colors.red,fontSize: 18),)),
                                          SizedBox(height: 10,),
                                          Divider(height: 1,color: Colors.grey,),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                              onTap:(){
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel",style: TextStyle(color: Colors.blue,fontSize: 18),)),

                                        ],
                                      ),
                                    ),
                                  );
                                });
                                     },
                                     child: Image.asset("assets/images/ic_delete.png")),
                                  Spacer(),
                                  Text("${provider.individualselect.length} Selected",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: (){
                                        provider.selectall=false;
                                        provider.selectedMessage.clear();
                                        provider.individualselect.clear();
                                      },
                                      child: Text("Cancel",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)),

                                ],
                              ),
                            ):sendMessage(context,provider),
                          ),
                        )
                      ],
                    ),
                  ),
                 /* sendMessage(context),*/
                ],
              ),
            ),
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

              width: double.infinity,
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

          Material(
            child: Row(
              children: [

                IconButton(
                  icon: Image.asset("assets/images/ic_sand.png"),
                  onPressed: () {
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
                    sendMessageKey.currentState!.save();
                    if (message == "") return;
                    final messageModel = MessageModel(
                        message: message,
                        sender: "user",
                        status: "Sending...",
                        quicktypest: [""],
                        time: formattedDate
                    );
                    provider.addMessage(messageModel);
                    provider.sendmessage(message);
                    messageModel.status=provider.messagestatus;
                    sendMessageKey.currentState!.reset();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}





