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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.only(top: 35,right: 30),
                      child: Image.asset(
                        "assets/images/v2_ic_u.png",
                        fit: BoxFit.fill,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: text == AppLocalizations.of(context)!.stories?55:0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: getProportionateScreenHeight(390),
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
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
                        fontSize: getProportionateScreenWidth(40),
                        fontWeight: FontWeight.bold,
                        color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                      ),
                    ),
                    Text(
                      text2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(13),
                          color: text != AppLocalizations.of(context)!.stories?Colors.white:Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}