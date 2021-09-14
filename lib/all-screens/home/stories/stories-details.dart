import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-details-controller.dart';
import 'package:share/share.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class StoryDetails extends StatefulWidget {
  String id = "";
  String title = "";
  String image = "";
  String date = "";

  StoryDetails(this.id, this.title, this.image, this.date);

  @override
  _StoryDetailsState createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {

  @override
  Widget build(BuildContext context) {
    var sp = locator<SPUtil>();
    Provider.of<StoryDetailsController>(context, listen: false)
        .getStoriesDetailsFromRemote(RemoteConfigData.getStoryDetailsUrl(
                sp.getValue(SPUtil.PROGRAMKEY)) +
            widget.id);
    String story_content = "";
    return Consumer<StoryDetailsController>(
        builder: (context, provider, snapshot) {
      story_content = provider.responseStoryDetails == null
          ? ""
          : provider.responseStoryDetails!.content;
      return Scaffold(
          body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_select_language.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 50, child: Icon(Icons.arrow_back))),
                        color: Colors.black,
                        onPressed: () {},
                      ),
                      getShareButton(widget.id)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  width: double.infinity,
                  child: loadLocalHTML(provider,
                      story_content, widget.title, widget.image, widget.date),
                ),
              ],
            ),
          ),
        ),
      ));
    });
  }


  getShareButton(String id) {
    return GestureDetector(
      onTap: () async {
        await Share.share("https://ureport.in/story/" + id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 30,
          width: 30,
          child: Icon(
            Icons.share,
            color: Colors.lightBlueAccent,
            size: 18,
          ),
        ),
      ),
    );
  }

  var cache_lock = true;
  late WebViewPlusController webViewController;

  loadLocalHTML(StoryDetailsController provider,String content, String title, String image, String date) {
    double _height = 1;

    return content == ""
        ? Container(
            margin: EdgeInsets.only(top: 30),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                CircularProgressIndicator(),
              ],
            ),
          )
        : WebViewPlus(
            onWebViewCreated: (controller) {
              webViewController = controller;
              controller.webViewController.clearCache();
              loadData();
              // webViewController.loadUrl(htmlFilePath);
            },
            onPageFinished: (url) {
              webViewController.getHeight().then((double height) {
                setState(() {
                  _height = height;
                });
              });
              // content = content.substring(0, min(content.length, 2097000));
              final dateTime = DateTime.parse(date);
              final format = DateFormat('dd MMMM, yyyy');
              final clockString = format.format(dateTime);

              webViewController.webViewController.evaluateJavascript(
                  'document.querySelector(".title").innerHTML = "$title";');
              webViewController.webViewController.evaluateJavascript(
                  'document.querySelector(".date_box").innerHTML = "$clockString";');
              webViewController.webViewController.evaluateJavascript(
                  'document.querySelector(".image_box").innerHTML = "<img src= $image>";');
              content = content.replaceAll("\"", "\'");
              print("Content : $content");
              webViewController.webViewController.evaluateJavascript(
                  'document.getElementById("sourceText").innerHTML = "$content";');

            },
            javascriptMode: JavascriptMode.unrestricted,
          );
  }

  loadData() async {
    String htmlFilePath = 'assets/storypage/pages/story.html';
    webViewController.loadUrl(htmlFilePath);
  }
}
