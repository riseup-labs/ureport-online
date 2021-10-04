import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Chat.dart';
class DummyChat extends StatefulWidget{


  @override
  _DummyChatState createState() => _DummyChatState();
}

class _DummyChatState extends State<DummyChat> {


  openRealChat(){
    showGeneralDialog(context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 2000),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context,Animation<double> animation, Animation<double> secondaryAnimation){

          return Chat();
        });
  }


  @override
  void initState() {


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       body: Container(
         color: Colors.white,
         child: Column(
           children: [
             TopBar.getTopBar(AppLocalizations.of(context)!.chat),
             SizedBox(height: 200,),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 GestureDetector(
                   onTap: (){
                     NavUtils.push(context, Chat());
                   },
                   child: Text("Start chat ",style: TextStyle(color: Colors.black,fontSize: 30),),
                 ),
               ],
             ),

             /* sendMessage(context),*/
           ],
         ),
       ),
     ),
   );
  }
}