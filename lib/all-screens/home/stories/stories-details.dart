import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'html_code.dart';

class StoryDetails extends StatelessWidget{
  String content="";
  StoryDetails(this.content);
  @override
  Widget build(BuildContext context) {
    //String content = HtmlCode.htmlCode;

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      return SafeArea(
          child: Scaffold(
              body: Stack(
                children: [getBackground(), getBody(content,context)],
              )));
    });
  }
}

getBackground() {
  return Image(
      image:
      AssetImage("assets/images/drawable-xxhdpi/bg_select_language.png"));
}

getBody(String content,context) {
  return Column(
    children: [getAppBar(context),getWebView(content)],
  );
}

getAppBar(context) {
  return Container(
    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),

        getShareButton()],
    ),
  );
}

getShareButton() {
  return Card(
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
  );
}

getWebView(String content) {

  final _key = UniqueKey();
  return Expanded(
    child: Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: WebView(
        key: _key,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: Uri.dataFromString(content,
            mimeType: 'text/html', encoding: Encoding.getByName("UTF-8")).toString(),
      ),
    ),
  );
}
