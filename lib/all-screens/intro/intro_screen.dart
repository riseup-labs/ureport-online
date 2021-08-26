
import 'package:flutter/material.dart';

import 'package:ureport_ecaro/utils/size_config.dart';

import 'body.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage("assets/images/drawable-ldpi/bg_about.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Body() /* add child content here */,
      ),
    );
  }
}