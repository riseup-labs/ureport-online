import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Logo
                  Container(
                    height: 70,
                  ),
                  //Image
                  Container(
                    margin: EdgeInsets.only(right: text == AppLocalizations.of(context)!.stories?55:0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: getProportionateScreenHeight(350),
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 180,
            color: text == AppLocalizations.of(context)!.opinions?AppColors.opinion_intro_back:null,
            child: Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(40),
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