import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';

import 'html_code.dart';

class StoryDetails extends StatelessWidget {
  String id = "";


  StoryDetails(this.id);

  @override
  Widget build(BuildContext context) {
    Provider.of<StoryController>(context, listen: false)
        .getStoriesDetailsFromRemote(
            ApiConst.RESULT_STORY_DETAILS_BASEURL + id);
    String story_content = "";

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      story_content = provider.responseStoryDetails==null?"":provider.responseStoryDetails!.content;

      return SafeArea(
          child: Scaffold(
              body: Stack(
        children: [getBackground(), getBody(story_content, context,id)],
      )));
    });
  }
}

getBackground() {
  return Image(
      image:
          AssetImage("assets/images/drawable-xxhdpi/bg_select_language.png"));
}

getBody(String content, context,String id) {
  return Column(
    children: [getAppBar(context,id),SizedBox(height: 10,), getWebView(content)],
  );
}

getAppBar(context,String id) {
  return Container(
    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        getShareButton(id)
      ],
    ),
  );
}

getShareButton(String id) {
  return GestureDetector(
    onTap: () async {
      await Share.share("https://ureport.in/story/"+id);
    },
    child: Card(
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
                mimeType: 'text/html', encoding: Encoding.getByName("UTF-8"))
            .toString(),
      ),
    ),
  );
}
