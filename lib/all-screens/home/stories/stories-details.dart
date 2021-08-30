import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-details-controller.dart';
import 'package:share/share.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class StoryDetails extends StatelessWidget {
  String id = "";
  String title = "";
  String image = "";

  StoryDetails(this.id, this.title, this.image);

  @override
  Widget build(BuildContext context) {
    var sp = locator<SPUtil>();
    Provider.of<StoryDetailsController>(context, listen: false)
        .getStoriesDetailsFromRemote(
        RemoteConfigData.getStoryDetailsUrl(sp.getValue(SPUtil.PROGRAMKEY)) + id);
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
          child: Container(
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.vertical,
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
                      getShareButton(id)
                    ],
                  ),
                ),
                Container(
                  child: CachedNetworkImage(
                      height: 200,
                      fit: BoxFit.fill,
                      imageUrl:
                          image != '' ? image : "assets/images/default.jpg",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Loading")
                                ],
                              ),
                      errorWidget: (context, url, error) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("No image found")
                            ],
                          )),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      getWebView(story_content, provider,context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    });
  }
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

getWebView(String content, StoryDetailsController provider,BuildContext context) {

  print("${content.length}");
  if (provider.responseStoryDetails != null) {
    provider.responseStoryDetails!.content = "";
  }


  final _key = UniqueKey();
  return Container(
    height: MediaQuery.of(context).size.height*4,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(left: 10, right: 10),
    child: content == ''
        ? Container(
      margin: EdgeInsets.only(top: 30),
      height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CircularProgressIndicator(),
            ],
          ),
        )
        : WebView(
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: Uri.dataFromString(content,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName("UTF-8"))
                .toString(),
      // gestureRecognizers: Set() ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
          ),

  );
}
