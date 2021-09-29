
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ChatAvatar.dart';
import 'chat-controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

  var isLoaded = true;

  var _spservice = locator<SPUtil>();
  TapGestureRecognizer tapGestureRecognizer=TapGestureRecognizer();


 bool isKeyboardOpen=false;

  @override
  void initState() {


    KeyboardVisibilityController().onChange.listen((event) {
      setState(() {
        isKeyboardOpen=event;
        if(isKeyboardOpen==true){
          Provider.of<ChatController>(context, listen: false).isExpanded=false;
        }
      });
      final message = event? "keyboardOpen":"keyboar close";
      print("keyboard status is........${message}");

    });

    if(_spservice.getValue(SPUtil.FIRSTMESSAGE)=="SENT"){
      Provider.of<ChatController>(context, listen: false).addQuickType();
    }
    Provider.of<ChatController>(context, listen: false).createContatct();
    Provider.of<ChatController>(context, listen: false)
        .getfirebaseInitialmessage();
    Provider.of<ChatController>(context, listen: false).getfirebase();
    Provider.of<ChatController>(context, listen: false).getfirebaseonApp(context);
    Provider.of<ChatController>(context, listen: false).loaddefaultmessage();
    Provider.of<ChatController>(context, listen: false).deletemsgAfterfiveDays();


    super.initState();
  }


  @override
  Widget build(BuildContext context) {


     print("the keyboard Status is...........${isKeyboardOpen}");

    return Consumer<ChatController>(
      builder: (context,provider,child){
        return  SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  TopBar.getTopBar(AppLocalizations.of(context)!.chat),
                  Container(
                    child: Divider(
                      height: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      child:  provider.localmessage.length>0  ?
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.localmessage.length>0 ? provider.localmessage.length:0,
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
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10,right: 5),
                                        child: provider.individualselect.contains(index) ?
                                        Container(
                                          height: 22,
                                          width: 22,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            border: Border.all(color: RemoteConfigData.getPrimaryColor()),
                                            color: RemoteConfigData.getPrimaryColor(),
                                          ),
                                        ):
                                        Container(
                                          height: 22,
                                          width: 22,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            border: Border.all(color: RemoteConfigData.getPrimaryColor()),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

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
                                        child: provider.getLinkClickable(provider.localmessage[index].message!).length>0?
                                        RichText(
                                          text: TextSpan(
                                            children: provider.getLinkClickable(provider.localmessage[index].message!)
                                                .map(
                                                  (data) => data.contains(provider.detectedlink.length>0?provider.detectedlink[0]:"nodata")
                                                  ? TextSpan(
                                                  text: " $data ",
                                                  style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                                  recognizer: tapGestureRecognizer
                                                    ..onTap=(){
                                                      String url = provider.detectedlink[0];
                                                      launch(url);
                                                    }
                                              )
                                                  : TextSpan(
                                                text: "${data} ",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            )
                                                .toList(),
                                          ),

                                        ):
                                        Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.left,)

                                      ):
                                      Container(
                                        padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 15),
                                        decoration: BoxDecoration(
                                          color:  RemoteConfigData.getPrimaryColor(),
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
                                                      border:Border.all(color: RemoteConfigData.getPrimaryColor(),),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: provider.localmessage[index].sender == 'server'
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10,),

                                    provider.localmessage[index].sender == "server" ? ChatAvatar("assets/images/ic_ureport_box.png") : SizedBox(),
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
                                            provider.getLinkClickable(provider.localmessage[index].message!).length>0?
                                            RichText(
                                                text: TextSpan(
                                                  children: provider.getLinkClickable(provider.localmessage[index].message!)
                                                      .map(
                                                        (data) => data.contains(provider.detectedlink.length>0?provider.detectedlink[0]:"nodata")
                                                        ? TextSpan(
                                                      text: " $data ",
                                                      style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                                          recognizer: tapGestureRecognizer
                                                            ..onTap=(){
                                                        String url = provider.detectedlink[0];
                                                        launch(url);
                                                            }
                                                    )
                                                        : TextSpan(
                                                      text: "${data} ",
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                  )
                                                      .toList(),
                                                ),

                                            ):
                                            Text(provider.localmessage[index].message!,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.w400),textAlign: TextAlign.left,)

                                          ):


                                          provider.localmessage[index].message!=""?Container(
                                            padding: EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 15),
                                            decoration: BoxDecoration(
                                              color:  provider.localmessage[index].message=="This Message was Deleted"?Color(0xffCCCCCC): RemoteConfigData.getPrimaryColor(),
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
                                          ):SizedBox(),



                                          SizedBox(
                                            height: 10,
                                          ),
                                          provider.localmessage[index].sender=="self" ||  provider.localmessage[index].sender=="server" && provider.quicdata(provider.localmessage[index].quicktypest.toString()).length>1 && provider.localmessage[index].quicktypest.isNotEmpty?
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

                                                      List<String> listDefault = RemoteConfigData.getDefaultAction();
                                                      List<String> listCaseManagement = RemoteConfigData.getOneToOneAction();
                                                      if(listDefault.contains(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString())){
                                                        locator<SPUtil>().setValue(SPUtil.USER_ROLE, "regular");
                                                        provider.sendmessage(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString());

                                                        provider.addMessage(messageModel);
                                                      }else if(listCaseManagement.contains(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString())){
                                                        locator<SPUtil>().setValue(SPUtil.USER_ROLE, "caseManagement");
                                                        provider.createIndividualCaseManagement(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString());


                                                      }else{

                                                        provider.sendmessage(provider.quicdata(provider.localmessage[index].quicktypest.toString())[j].toString());
                                                        provider.addMessage(messageModel);
                                                      }

                                                       messageModel.status=provider.messagestatus;
                                                      provider.replaceQuickReplaydata(index,provider.quicdata(provider.localmessage[index].quicktypest.toString())[j]);

                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(8),
                                                      margin: EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                          color:Colors.white,
                                                          border:Border.all(color: RemoteConfigData.getPrimaryColor()),
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
                                          SizedBox(height: 10,)
                                        ],
                                      ),
                                    ),
                                    provider.localmessage[index].sender == "self" || provider.localmessage[index].sender == "server" ? SizedBox() : ChatAvatar("assets/images/ic_user_box.png"),
                                    SizedBox(width: 10,),

                                  ],
                                ),

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
                  provider.isMessageCome==true? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      ChatAvatar("assets/images/ic_ureport_box.png"),
                      SizedBox(width: 10,),
                      Lottie.asset('assets/local-json/chatloading.json',height: 20,width: 40),
                    ],
                  )
                      : SizedBox(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(width: 7,),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 3,),
                                  GestureDetector(
                                    onTap: (){
                                      showDialog(context: context, builder: (_){

                                        return Dialog(

                                          child: Container(
                                            padding: EdgeInsets.only(left: 5,right: 5,bottom: 10),

                                            width: double.infinity,
                                            height: 150,
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
                                                    Expanded(child: Text("Are You Sure?Do you want to delete this message? ",style:TextStyle(color:Colors.red,fontSize: 15),textAlign: TextAlign.center,)),

                                                  ],
                                                ),
                                                SizedBox(height: 10,),
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
                                                    child: Text("Cancel",style: TextStyle(color: RemoteConfigData.getPrimaryColor(),fontSize: 18),)),

                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    child: Image.asset("assets/images/ic_delete.png",height: 35,width: 35,),
                                  ),

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
                                  SizedBox(width: 10,),
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
         provider.isExpanded==true || isKeyboardOpen==false? Row(
            mainAxisAlignment: MainAxisAlignment.start,
           children: [

             GestureDetector(
               onTap: (){
                 provider.addQuickType();
                 provider.isExpanded=false;
               },
               child: Container(
                 height: 30,
                 width: 30,
                 padding: EdgeInsets.all(4),
                 child: Image.asset("assets/images/ic_chat_menu.png",),
               ),
             ),
             SizedBox(width: 10,),
             GestureDetector(
               onTap: (){
                 provider.addQuickTypeCaseManagement();
                 provider.isExpanded=false;
               },
               child: Container(
                 height: 30,
                 width: 30,
                 padding: EdgeInsets.all(4),
                 child: Image.asset("assets/images/ic_one_to_one_chat.png",),
               ),
             ),

           ],
         ):
          GestureDetector(
            onTap: (){
              provider.isExpanded=true;
             // provider.addQuickType();
            },
            child: Container(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(4),
              child: Image.asset("assets/images/ic_arrow_chat.png",),
            ),
          ),

          Expanded(
            child: Container(

              width: double.infinity,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(

              ),

              child: TextFormField(
                autofocus: true,
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

                    List<String> listDefault = RemoteConfigData.getDefaultAction();
                    List<String> listCaseManagement = RemoteConfigData.getOneToOneAction();

                    if(listDefault.contains(message)){
                      locator<SPUtil>().setValue(SPUtil.USER_ROLE, "regular");
                    }else if(listCaseManagement.contains(message)){
                      locator<SPUtil>().setValue(SPUtil.USER_ROLE, "caseManagement");
                    }

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





