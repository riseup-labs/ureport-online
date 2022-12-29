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
    required this.region,
  }) : super(key: key);
  final String text, text2, image, region;

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    print(region);
    return Container(
      child: text == AppLocalizations.of(context)!.stories
          ?
          //Stories
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                region != 'ro' ? SizedBox(height: 130) : SizedBox(),
                region == 'ro'
                    ? StoriesTextWidget(text: text, text2: text2)
                    : SizedBox(height: 20),
                region != 'ro'
                    ? StoriesImageWidget(
                        image: image,
                        region: region,
                      )
                    : SizedBox(),
                region != 'ro'
                    ? StoriesTextWidget(text: text, text2: text2)
                    : SizedBox(),
                region == 'ro'
                    ? StoriesImageWidget(
                        image: image,
                        region: region,
                      )
                    : SizedBox(),
              ],
            )
          :

          //Chat
          text == AppLocalizations.of(context)!.chat
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    region != 'ro' ? SizedBox(height: 160) : SizedBox(),
                    region == 'ro'
                        ? ChatTextWidget(
                            text: text,
                            text2: text2,
                            region: region,
                          )
                        : SizedBox(height: 20),
                    region != 'ro'
                        ? ChatImageWidget(
                            image: image,
                            region: region,
                          )
                        : SizedBox(),
                    region != 'ro'
                        ? ChatTextWidget(
                            text: text,
                            text2: text2,
                            region: region,
                          )
                        : SizedBox(),
                    region == 'ro'
                        ? ChatImageWidget(
                            image: image,
                            region: region,
                          )
                        : SizedBox(),
                  ],
                )
              :

              //Opinion
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    region != 'ro' ? SizedBox(height: 170) : SizedBox(),
                    region == 'ro'
                        ? OpinionTextWidget(
                            text: text,
                            text2: text2,
                            region: region,
                          )
                        : SizedBox(height: 20),
                    region != 'ro'
                        ? OpinionImageWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: image,
                            region: region,
                          )
                        : SizedBox(),
                    region != 'ro'
                        ? OpinionTextWidget(
                            text: text,
                            text2: text2,
                            region: region,
                          )
                        : SizedBox(),
                    region == 'ro'
                        ? OpinionImageWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: image,
                            region: region,
                          )
                        : SizedBox(),
                  ],
                ),
    );
  }
}

class OpinionTextWidget extends StatelessWidget {
  const OpinionTextWidget({
    Key? key,
    required this.text,
    required this.text2,
    required this.region,
  }) : super(key: key);

  final String text;
  final String text2;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      color: region == 'ro'
          ? Colors.white
          : text == AppLocalizations.of(context)!.opinions
              ? AppColors.opinion_intro_back
              : null,
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
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
                  color: region == 'ro'
                      ? Colors.black
                      : text != AppLocalizations.of(context)!.stories
                          ? Colors.white
                          : Colors.black),
            ),
            Text(
              text2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  color: region == 'ro'
                      ? Colors.black
                      : text != AppLocalizations.of(context)!.stories
                          ? Colors.white
                          : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class OpinionImageWidget extends StatelessWidget {
  const OpinionImageWidget({
    Key? key,
    required this.devicePixelRatio,
    required this.image,
    required this.region,
  }) : super(key: key);

  final double devicePixelRatio;
  final String image;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: devicePixelRatio == 3 ? 80 : 0),
        width: double.infinity,
        child: Image.asset(
          image,
          fit: region == "ro" ? BoxFit.contain : BoxFit.fill,
        ),
      ),
    );
  }
}

class ChatTextWidget extends StatelessWidget {
  const ChatTextWidget({
    Key? key,
    required this.text,
    required this.text2,
    required this.region,
  }) : super(key: key);

  final String text;
  final String text2;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      color: text == AppLocalizations.of(context)!.opinions
          ? AppColors.opinion_intro_back
          : null,
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
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
                  color: region == 'ro'
                      ? Colors.black
                      : text != AppLocalizations.of(context)!.stories
                          ? Colors.white
                          : Colors.black),
            ),
            Text(
              text2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  color: region == 'ro'
                      ? Colors.black
                      : text != AppLocalizations.of(context)!.stories
                          ? Colors.white
                          : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatImageWidget extends StatelessWidget {
  const ChatImageWidget({Key? key, required this.image, required this.region})
      : super(key: key);

  final String image;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 50),
        child: Image.asset(
          image,
          fit: region == "ro" ? BoxFit.contain : BoxFit.fill,
        ),
      ),
    );
  }
}

class StoriesImageWidget extends StatelessWidget {
  const StoriesImageWidget({
    Key? key,
    required this.image,
    required this.region,
  }) : super(key: key);

  final String image;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Image.asset(
          image,
          fit: region == "ro" ? BoxFit.contain : BoxFit.fill,
        ),
      ),
    );
  }
}

class StoriesTextWidget extends StatelessWidget {
  const StoriesTextWidget({
    Key? key,
    required this.text,
    required this.text2,
  }) : super(key: key);

  final String text;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      color: text == AppLocalizations.of(context)!.opinions
          ? AppColors.opinion_intro_back
          : null,
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
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
                  color: text != AppLocalizations.of(context)!.stories
                      ? Colors.white
                      : Colors.black),
            ),
            Text(
              text2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  color: text != AppLocalizations.of(context)!.stories
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
