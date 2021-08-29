import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String about_text = "U-Report is a free tool for community participation, designed to address issues that the population cares about. Once a U-Reporter has followed U-Report Global on Facebook messenger polls and alerts are sent via Direct Message and real-time responses are collected and mapped on this site. Results and ideas are shared back with the community. Issues polled include health, education, water, sanitation and hygiene, youth unemployment, HIV/AIDS, disease outbreaks and anything else people want to discuss.";
    String title = "About U-Report";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            color: Colors.black,
            onPressed: () {},
          ),
          backgroundColor: Colors.white,
          title: Text(
            "${AppLocalizations.of(context)!.about_us}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.bluelight,
          ),
          child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  getLogo(),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 30, bottom: 20),
                            child: Text(
                              title,
                              style : TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 0, bottom: 40, right: 20),
                            child: Text(
                              about_text,
                              style : TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

getLogo() {
  return Image(
    fit: BoxFit.fill,
    image: AssetImage("assets/images/drawable-ldpi/ureport_logo.png"),
    height: 40,
    width: 200,
  );
}
