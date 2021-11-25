import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/detect_device_type.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.text2,
    required this.image,
  }) : super(key: key);
  final String text, text2, image;

  @override
  Widget build(BuildContext context) {

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    print(" pixel ratio : ${devicePixelRatio} \n height : ${height} \n width : ${width}");

    return Container(
      child: text == AppLocalizations.of(context)!.stories?
          //Stories
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 130),
          Expanded(
            child: Container(
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 30),
            color: text == AppLocalizations.of(context)!.opinions?AppColors.opinion_intro_back:null,
            child: Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(35),
                      fontWeight: FontWeight.bold,
                      color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                  Text(
                    text2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ) :
      text == AppLocalizations.of(context)!.stories?
          //Chat
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 130),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 30),
            color: text == AppLocalizations.of(context)!.opinions?AppColors.opinion_intro_back:null,
            child: Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(35),
                        fontWeight: FontWeight.bold,
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                  Text(
                    text2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ) :
          //Opinion
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 130),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: devicePixelRatio == 3 ? 80 : 0),
              width: double.infinity,
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 30),
            color: text == AppLocalizations.of(context)!.opinions?AppColors.opinion_intro_back:null,
            child: Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(35),
                        fontWeight: FontWeight.bold,
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                  Text(
                    text2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}