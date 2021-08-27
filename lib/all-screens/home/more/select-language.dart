
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/resources.dart';

class SelectLanguage extends StatefulWidget{
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {

  bool _value = false;
  int val = -1;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Color(0xffF5FCFF),
     appBar:AppBar(
       backgroundColor: Colors.white,
       title: Text("Language",style: TextStyle(color:Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
       leading: Icon(Icons.arrow_back,color: Colors.black,),
       actions: [
         Card(
           elevation: 2,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(25),
           ),
           child: Container(
             height: 50,
             width: 50,
             padding: EdgeInsets.all(10),
             child: Icon(
               Icons.share,
               color: Colors.lightBlueAccent,
             ),
           ),
         )
       ],
     ),
     body: SafeArea(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SizedBox(height: 25,),
           Text("Select Language",style: TextStyle(color: Colors.black,fontSize: 20)),
           SizedBox(height: 30,),
           Container(
             margin: EdgeInsets.all(25),
             padding: EdgeInsets.all(15),
             height: 361,
             width: 353,
             decoration: BoxDecoration(
                 color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(5)),
             ),
             child: Expanded(
               child: Column(
                 children: [

                   ListTile(
                     title: Text("English",style: TextStyle(color: Colors.black,fontSize: 15)),
                     trailing: Radio(
                       value: 1,
                       onChanged: (int?value) {
                         setState(() {
                          bsetSelectedRadio(value);
                         });
                       },

                       groupValue:val,

                     ),
                   ),
                   Divider(height: 1,color: Color(0xffF5FCFF),),
                   ListTile(
                     title: Text("English",style: TextStyle(color: Colors.black,fontSize: 15)),
                     trailing: Radio(
                       value: 1,
                       onChanged: (value) {
                         setState(() {
                           val=1;
                         });
                       },
                       groupValue:val,

                     ),
                   ),
                   Divider(height: 1,color: Color(0xffF5FCFF),),
                   ListTile(
                     title: Text("English",style: TextStyle(color: Colors.black,fontSize: 15)),
                     trailing: Radio(
                       value: 1,
                       onChanged: (value) {
                         setState(() {
                           val=1;
                         });
                       },
                       groupValue:val,

                     ),
                   ),
                   Divider(height: 1,color: Color(0xffF5FCFF),),
                   ListTile(
                     title: Text("English",style: TextStyle(color: Colors.black,fontSize: 15)),
                     trailing: Radio(
                       value: 1,
                       onChanged: (value) {
                         setState(() {
                           val=1;
                         });
                       },
                       groupValue:val,

                     ),
                   ),
                   Divider(height: 1,color: Color(0xffF5FCFF),),
                   ListTile(
                     title: Text("English",style: TextStyle(color: Colors.black,fontSize: 15)),
                     trailing: Radio(
                       value: 1,
                       onChanged: (value) {
                         setState(() {
                           val=1;
                         });
                       },
                       groupValue:val,

                     ),
                   ),
                   Divider(height: 1,color: Color(0xffF5FCFF),),


                 ],
               ),
             ),
           ),

         ],
       ),
     ),
   );
  }

  void bsetSelectedRadio( value) {
    setState(() {
      val =value;
    });
  }
}