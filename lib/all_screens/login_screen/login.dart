

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all_screens/login_screen/provider_login_controller.dart';

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Provider.of<ProviderLoginController>(context,listen: false).getfirebase();
    Provider.of<ProviderLoginController>(context,listen: false).getfirebase();
    return Consumer<ProviderLoginController>(

      builder: (context,provider,child){
        return Scaffold(

          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              RaisedButton(
                  child: Text("create contact"),
                  onPressed: (){

                    provider.createContatct();
              }),

              SizedBox(height: 15,),
              RaisedButton(
                  child: Text("send message"),
                  onPressed: ()async{

                    await provider.sendmessage();
                  }),

              SizedBox(height: 15,),
              RaisedButton(
                  child: Text("startflow"),
                  onPressed: ()async{

                    await provider.startflow();
                  }),


              SizedBox(height: 15,),
              RaisedButton(
                  child: Text("start last flow"),
                  onPressed: ()async{

                    await provider.startlastFlow();
                  }),

            ],
          ),

        );
      },

    );
  }

}