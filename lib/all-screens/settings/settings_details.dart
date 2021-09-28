
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class SettingDetails extends StatefulWidget{
  @override
  _SettingDetailsState createState() => _SettingDetailsState();
}

class _SettingDetailsState extends State<SettingDetails> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  var spservice = locator<SPUtil>();
  late String switchstate;
  bool statesf=true;
    @override
  void initState() {
    switchstate= spservice.getValue(SPUtil.DELETE5DAYS);
    if(switchstate=="true"){
      statesf=true;
    }else statesf=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffF5FCFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text("Settings",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 0),

            margin: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Text("Notification",style: TextStyle(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
               SizedBox(height: 15,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/ic_sound.png",height: 15,width: 15,),
                    SizedBox(width: 8,),
                    Text("ON/OFF",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700),),
                    Spacer(),
                    Expanded(
                      child: SwitchListTile(
                          value: true, onChanged: (value){}
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          Container(

            padding: EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 0),

            margin: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Text("Sound",style: TextStyle(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/ic_sound.png",height: 15,width: 15,),
                    SizedBox(width: 8,),
                    Text("ON/OFF",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700),),
                    Spacer(),
                    Expanded(
                      child: SwitchListTile(
                          value: true, onChanged: (value){}
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
            margin: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Chat",style: TextStyle(color: Colors.black,fontSize: 21,fontWeight: FontWeight.bold),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/ic_chatt.png",height: 15,width: 15,),
                    SizedBox(width: 8,),
                    Expanded(child: Text("Automatically remove messages after 5 days",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700),)),
                    SizedBox(width: 20,),
                    Switch(
                        value: statesf, onChanged: (value){

                          setState(() {
                            statesf=value;
                            spservice.setValue(SPUtil.DELETE5DAYS, value.toString());
                          });

                    }
                    ),
                    SizedBox(width: 18,)

                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/ic_chatt.png",height: 15,width: 15,),
                    SizedBox(width: 8,),
                    Text("Remove all messages",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700),),
                    Spacer(),
                    GestureDetector(
                      onTap: ()async{

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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  SizedBox(height: 5,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Are you sure you want to delete? ",style:TextStyle(color:Colors.red,fontSize: 15)),

                                    ],
                                  ),
                                  SizedBox(height: 5,),

                                  GestureDetector(
                                      onTap:()async{
                                        await _databaseHelper.deleteConversation().then((value) {

                                          Navigator.pop(context);
                                          Provider.of<ChatController>(context, listen: false).localmessage.clear();
                                          Provider.of<ChatController>(context, listen: false).notifyListeners();

                                        });
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
                      child: Container(
                        padding: EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xff41B6E6),
                        ),
                        child: Text("Remove",style: TextStyle(color: Colors.white,fontSize: 10),),
                      ),
                    ),
                    SizedBox(width: 15,),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}