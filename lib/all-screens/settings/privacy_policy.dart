import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/resources.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String t_text = "Individual messages are confidential but aggregated data is transparent. Information received can be disaggregated by age, gender and country in real time and is used to connect young people with their representatives, improve UNICEF programmes and draw attention to urgent issues with national governments and the UN. NGOs, civil society and country leaders can see the information on the site to understand what the people want or need. Registration is voluntary and U-Reporters incur no costs. There are 41 national U-Report programmes in addition to the global project and the amount of people joining increases everyday. U-Report relies on volunteer community members serving as U-Reporters to provide information on issues in their communities to create change. In return U-Reporters will receive important information and alerts around international issues. Together we create change. ACCESSIBILITY STANDARDS FOR UNICEF WEBSITES";
    String title = "Privacy policy";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {},
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Privacy Policy",
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, top: 30, bottom: 20),
                            child: Text(
                              title,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, top: 0, bottom: 40, right: 20),
                            child: Text(
                              t_text,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
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
