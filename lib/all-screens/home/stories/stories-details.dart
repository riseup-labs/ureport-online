import 'dart:convert';
import 'dart:io';
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
import 'package:path_provider/path_provider.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider
        .of<StoryDetailsController>(context, listen: false)
        .responseStoryDetails = null;
  }

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
                                        width: 50,
                                        child: Icon(Icons.arrow_back))),
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
                          child: loadLocalHTML(
                              provider, story_content, widget.title,
                              widget.image, widget.date),
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

  late WebViewPlusController webViewController;

  loadLocalHTML(StoryDetailsController provider, String content, String title, String image, String date) {
    double _height = 1;

    return content == ""
        ? Container(
      margin: EdgeInsets.only(top: 30),
      height: MediaQuery
          .of(context)
          .size
          .height,
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
        // loadData();
        loadDataRaw(content,title,image,date);
      },
      onPageFinished: (url) {
        webViewController.getHeight().then((double height) {
          setState(() {
            _height = height;
          });
        });
        // content = content.substring(0, min(content.length, 2097000));


        // content = content.replaceFirst(RegExp('(?s)<img.*?>'), '');

        // webViewController.webViewController.evaluateJavascript(
        //     'document.querySelector(".title").innerHTML = "$title";');
        // webViewController.webViewController.evaluateJavascript(
        //     'document.querySelector(".date_box").innerHTML = "$clockString";');
        // webViewController.webViewController.evaluateJavascript(
        //     'document.querySelector(".image_box").innerHTML = "<img src= $image>";');

        content = content.replaceAll("\"", "\'");
        content = content.replaceAll("\\", "");

        String contentEx = content;
        if (contentEx.length > 2097152) {
          contentEx = contentEx.replaceFirst(RegExp('<img.*?>'), '');
          if (contentEx.length > 2097152) {
            contentEx = contentEx.replaceFirst(RegExp('<img.*?>'), '');
            print("Content length3 : ${contentEx.length}");
            evaluateScript(contentEx);
          } else {
            print("Content length2 : ${contentEx.length}");
            evaluateScript(contentEx);
          }
        } else {
          print("Content length1 : ${contentEx.length}");
          evaluateScript(contentEx);
        }
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  evaluateScript(String content){
    webViewController.webViewController.evaluateJavascript(
        'document.getElementById("sourceText").innerHTML = "$content";');
  }

  loadData() {
    String htmlFilePath = 'assets/storypage/pages/story.html';
    webViewController.loadUrl(htmlFilePath);
  }

  loadDataRaw(String content,String title, String image, String date) {
    String contentEx = content.split('').reversed.join();
    if (contentEx.length > 2097152) {
      contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
      if (contentEx.length > 2097152) {
        contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
        loadHtml(contentEx.split('').reversed.join(),title,image,date);
        // loadHtml(contentEx);
      } else {
        loadHtml(contentEx.split('').reversed.join(),title,image,date);
      }
    } else {
      loadHtml(contentEx.split('').reversed.join(),title,image,date);
      // String htmlFilePath = 'assets/storypage/pages/story.html';
      // webViewController.loadUrl(htmlFilePath);
    }
  }

  loadHtml(String content, String title, String image, String date) {

    final dateTime = DateTime.parse(date);
    final format = DateFormat('dd MMMM, yyyy');
    final clockString = format.format(dateTime);

    String final_content = '''
    <html> 
    <style> 
    img{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    iframe{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    body{width: 90% !important;margin-left: auto;margin-right: auto;display: block;margin-top:10px;margin-bottom:10px;} 
    p{font-size: 24px;}
    </style> 
    <body> 
    <div><h5>$clockString/h5></div>
    <div><h2>$title</h2></div>
    <div class="image_box"><img class = "title_image" src="$image"></div>
    <div>$content</div> 
    </body> 
    </html>''';

    webViewController.loadUrl(Uri.dataFromString(final_content,
        mimeType: 'text/html',
        encoding: Encoding.getByName("UTF-8"))
        .toString());
  }
}