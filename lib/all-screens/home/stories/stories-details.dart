import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/save_story.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-details-controller.dart';
import 'package:share/share.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

  var sp = locator<SPUtil>();
  String storyContent = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    StorageUtil.readStory("${sp.getValue(SPUtil.PROGRAMKEY)}_${widget.id}").then((String value) {
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
              webViewController.webViewController
                  .canGoBack().then((value) => {
                if(value){
                  webViewController.webViewController.
                  goBack()
                }else{
                  Navigator.pop(context)
                }
              }
              );
              return false;
            },
            child: Scaffold(
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
                                        webViewController.webViewController
                                            .canGoBack().then((value) => {
                                        if(value){
                                            webViewController.webViewController.
                                            goBack()
                                      }else{
                                        Navigator.pop(context)
                                        }
                                      }
                                        );
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
                                provider, storyContent, widget.title,
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

  doShare() async{
    await Share.share("${RemoteConfigData.getStoryShareUrl()}" + "1024");
  }

  getShareButton(String id) {
    return GestureDetector(
      onTap: () async {
        await Share.share("${RemoteConfigData.getStoryShareUrl()}" + id);
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

  loadLocalHTML(StoryDetailsController provider, String content, String title,
      String image, String date) {
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
        loadDataRaw(content, title, image, date);
      },
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

  evaluateScript(String content) {
    webViewController.webViewController.evaluateJavascript(
        'document.getElementById("sourceText").innerHTML = "$content";');
  }

  loadData() {
    String htmlFilePath = 'assets/storypage/pages/story.html';
    webViewController.loadUrl(htmlFilePath);
  }

  loadDataRaw(String content, String title, String image, String date) {
    String contentEx = content
        .split('')
        .reversed
        .join();
    if (contentEx.length > 2097152) {
      contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
      if (contentEx.length > 2097152) {
        contentEx = contentEx.replaceFirst(RegExp('>.*?gmi<'), '');
        loadHtml(contentEx
            .split('')
            .reversed
            .join(), title, image, date);
        // loadHtml(contentEx);
      } else {
        loadHtml(contentEx
            .split('')
            .reversed
            .join(), title, image, date);
      }
    } else {
      loadHtml(contentEx
          .split('')
          .reversed
          .join(), title, image, date);
    }
  }

  loadHtml(String content, String title, String image, String date) {
    final dateTime = DateTime.parse(date);
    final format = DateFormat('dd MMMM, yyyy');
    final clockString = format.format(dateTime);
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br><br>", "<br><br>");
    content = content.replaceAll("<br><br><br>", "<br><br>");


    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n\n", "\n\n");
    content = content.replaceAll("\n\n\n", "\n\n");






    String final_content = '''
    <html> 
    <style> 
    img{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    iframe{width: 100% !important;margin-left: auto;margin-right: auto;display: block;margin-top:20px;margin-bottom:20px;} 
    body{width: 90% !important;margin-left: auto;margin-right: auto;display: block;margin-top:10px;margin-bottom:10px;} 
    p{font-size: 24px;}
    
    .header_time{
       float: left;
       font-size: 20px;
    }
    .header_share{
      float: right;
    }
    </style> 
    <body> 
    <div class="image_box"><img class = "title_image" src="$image"></div>
    <div class="header_group">
      <div class="header_time">$clockString</div>
      <div class="header_share"><button onclick="getFunction()">Clock</button></div> 
    </div>
    
    
    <div style="float: left;"><h2>$title</h2></div>
    <div>$content</div> 
    </body> 
    <script>
      function getFunction(){
        console.log("ok working");
        window.doShare();
      }
    </script>
    </html>''';

    webViewController.loadUrl(Uri.dataFromString(final_content,
        mimeType: 'text/html',
        encoding: Encoding.getByName("UTF-8"))
        .toString());
  }
}