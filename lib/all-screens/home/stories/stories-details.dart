import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/save_story.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-details-controller.dart';
import 'package:share/share.dart';
import 'package:ureport_ecaro/all-screens/home/stories/utils/story_details_utils.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  var sp = locator<SPUtil>();
  String storyContent = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ConnectivityController>(context, listen: false).startMonitoring();
    StorageUtil.readStory("${sp.getValue(SPUtil.PROGRAMKEY)}_${widget.id}")
        .then((String value) {
      setState(() {
        storyContent = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryDetailsController>(
        builder: (context, provider, snapshot) {
      return WillPopScope(
        onWillPop: () async {
          webViewController.webViewController.canGoBack().then((value) => {
                if (value)
                  {
                    webViewController.webViewController.goBack(),
                    ClickSound.soundClose()
                  }
                else
                  {Navigator.pop(context), ClickSound.soundClose()}
              });
          return false;
        },
        child: Scaffold(
            body: SafeArea(
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 70,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 55,
                                    child: IconButton(
                                      icon: Container(
                                          height: 60,
                                          width: 120,
                                          child: Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/v2_ic_back.png"),
                                          )),
                                      color: Colors.black,
                                      onPressed: () {
                                        webViewController.webViewController
                                            .canGoBack()
                                            .then((value) => {
                                          if (value)
                                            {
                                              webViewController.webViewController
                                                  .goBack(),
                                              ClickSound.soundClose()
                                            }
                                          else
                                            {
                                              Navigator.pop(context),
                                              ClickSound.soundClose()
                                            }
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: Center(
                                          child: getShareButton(widget.id),
                                        ),
                                      )
                                  )

                                ],
                              ),
                            )),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: CustomPaint(
                                  painter: CustomBackground(),
                                  child: Container(
                                    height: 80,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.stories,
                                          style: TextStyle(
                                              fontSize: 26.0,
                                              color:
                                                  RemoteConfigData.getTextColor(),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Divider(
                          height: 1.5,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 71.5),
                    width: double.infinity,
                    child: loadLocalHTML(provider, storyContent, widget.title,
                        widget.image, widget.date),
                  ),
                ],
              ),
            ),
          ),
        )),
      );
    });
  }

  getShareButton(String id) {
    return GestureDetector(
      onTap: () async {
        ClickSound.soundClick();
        await Share.share("${RemoteConfigData.getStoryShareUrl()}" + id);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.share,
              style: TextStyle(
                  fontSize: 17, color: RemoteConfigData.getPrimaryColor()),
            ),
            SizedBox(
              width: 5,
            ),
            Image(
              image: AssetImage("assets/images/ic_share.png"),
              height: 20,
              width: 20,
              color: RemoteConfigData.getPrimaryColor(),
            )
          ],
        ),
      ),
    );
  }

  late WebViewPlusController webViewController;

  loadLocalHTML(StoryDetailsController provider, String content, String title,
      String image, String date) {
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
              // loadData();
              loadDataRaw(content, title, image, date);
            },
            // javascriptChannels: Set.from([
            //   JavascriptChannel(
            //       name: 'Print',
            //       onMessageReceived: (JavascriptMessage message) {
            //         doShare();
            //       })
            // ]),
            onPageFinished: (url) {
              webViewController.getHeight().then((double height) {
                setState(() {
                  _height = height;
                });
              });
              content = content.replaceAll("\"", "\'");
              content = content.replaceAll("\\", "");
            },
            javascriptMode: JavascriptMode.unrestricted,
          );
  }

  loadDataRaw(String content, String title, String image, String date) {
    String contentEx = content.split('').reversed.join();
    if (contentEx.length > 2097152) {
      contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
      if (contentEx.length > 2097152) {
        contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
        loadHtml(contentEx.split('').reversed.join(), title, image, date);
        // loadHtml(contentEx);
      } else {
        loadHtml(contentEx.split('').reversed.join(), title, image, date);
      }
    } else {
      loadHtml(contentEx.split('').reversed.join(), title, image, date);
    }
  }

  loadHtml(String content, String title, String image, String date) {
    final dateTime = DateTime.parse(date);
    final format = DateFormat('dd MMMM, yyyy');
    final clockString = format.format(dateTime);
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>",
        "<br><br>");
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll(
        "<br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content =
        content.replaceAll("<br><br><br><br><br><br><br><br><br>", "<br><br>");
    content =
        content.replaceAll("<br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br>", "<br><br>");

    String final_content = '''
    <html> 
    
    <style> 
    ${StoryUtils.style}
    img{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    iframe{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    body{width: 90% !important;margin-left: auto;margin-right: auto;display: block;margin-top:10px;margin-bottom:10px;} 
    p{font-size: 24px;}
    span{font-size: 16px !important; line-height: 1.6 !important;}
    .header_group{
      display: inline-flex;
    }
    .header_group img {
      height: 20px;
      margin: 0 0 0 5px !important;
    }
    .header_time{
       float: left;
       margin-top: 3px;
       font-size: 14px;
       font-weight: bold;
    }
    .header_share{
      float: right;
      margin-right: 20px;
    }
    </style> 
    <body> 
    <div class="image_box"><img class = "title_image" src="$image"></div>
      <div class="header_time">$clockString</div>
    <div style="float: left; font-weight: bold; margin-top:10px; margin-bottom: 10px; font-size: 20px "><h2>$title</h2></div>
    <div  style="float: left;">$content</div> 
    </body> 
    </html>''';

    String final_content_offline = '''
    
    <html> 
    
    <style> 
    ${StoryUtils.style}
    img{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    iframe{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    body{width: 90% !important;margin-left: auto;margin-right: auto;display: block;margin-top:10px;margin-bottom:10px;} 
    p{font-size: 24px;}
    span{font-size: 16px !important; line-height: 1.6 !important;}
    .header_group{
      display: inline-flex;
    }
    .header_group img {
      height: 20px;
      margin: 0 0 0 5px !important;
    }
    .header_time{
       float: left;
       margin-top: 3px;
       font-size: 14px;
       font-weight: bold;
    }
    .header_share{
      float: right;
      margin-right: 20px;
    }
    </style> 
    <body> 
    <div class="header_time">$clockString</div>
    <div style="float: left; font-weight: bold; margin-top:10px; margin-bottom: 10px; font-size: 20px "><h2>$title</h2></div>
    <div  style="float: left;">$content</div> 
    </body> 
    </html>''';


    if(Provider.of<ConnectivityController>(context, listen: false).isOnline){
      webViewController.loadUrl(Uri.dataFromString(final_content,
          mimeType: 'text/html', encoding: Encoding.getByName("UTF-8"))
          .toString());
    }else{
      webViewController.loadUrl(Uri.dataFromString(final_content_offline,
          mimeType: 'text/html', encoding: Encoding.getByName("UTF-8"))
          .toString());
    }

  }
}
