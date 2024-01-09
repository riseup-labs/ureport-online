import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/home/stories/utils/story_details_utils.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/loading_bar.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'about_controller.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late WebViewPlusController webViewController;
  double _height = 1;
  var sp = locator<SPUtil>();

  @override
  void initState() {
    super.initState();

    Provider.of<AboutController>(context, listen: false).startMonitoring();

    Provider.of<AboutController>(context, listen: false).data =
        sp.getValueNoNull(
            "${SPUtil.ABOUT_DATA}_${sp.getValue(SPUtil.PROGRAMKEY)}");
    Provider.of<AboutController>(context, listen: false).title =
        sp.getValueNoNull(
            "${SPUtil.ABOUT_TITLE}_${sp.getValue(SPUtil.PROGRAMKEY)}");

    Provider.of<AboutController>(context, listen: false).aboutData = null;

    Provider.of<AboutController>(context, listen: false).getAboutFromRemote(
        RemoteConfigData.getAboutUrl(sp.getValue(SPUtil.PROGRAMKEY)!));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutController>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 0.0,
          ),
          body: Container(
            child: Stack(
              children: [
                Container(
                  height: 80,
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ClickSound.soundClose();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Image(
                            height: 60,
                            width: 60,
                            image: AssetImage("assets/images/v2_ic_back.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                provider.data != ""
                    ? Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 80),
                        child: WebViewPlus(
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                            controller.webViewController.clearCache();
                            if (provider.isOnline) {
                              getContent(provider.title, provider.data);
                            } else {
                              getContentOffline(provider.title, provider.data);
                            }
                          },
                          onPageFinished: (url) {
                            webViewController.getHeight().then((double height) {
                              setState(() {
                                _height = height;
                              });
                            });
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      )
                    : provider.isOnline
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: LoadingBar.spinkit),
                          )
                        : noInternetDialog(context),
              ],
            ),
          ),
        );
      },
    );
  }

  noInternetDialog(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      AlertDialog alert = AlertDialog(
        content: Text(AppLocalizations.of(context)!.no_internet_text),
        actions: [
          TextButton(
            child: Text(
              "${AppLocalizations.of(context)!.back}",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              ClickSound.soundClick();
              NavUtils.pushAndRemoveUntil(context, NavigationScreen(3));
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.retry),
            onPressed: () {
              ClickSound.soundClick();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Provider.of<AboutController>(context, listen: false).aboutData =
                  null;
              Provider.of<AboutController>(context, listen: false)
                  .getAboutFromRemote(RemoteConfigData.getAboutUrl(
                      sp.getValue(SPUtil.PROGRAMKEY)!));
            },
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
  }

  getContent(String title, String content) {
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
    <!ECOTYPE html>
    <html> 
    <style>
    ${sp.getValue(SPUtil.PROGRAMKEY) == "Global" ? StoryUtils.styleItalia : sp.getValue(SPUtil.PROGRAMKEY) == "Italia" ? StoryUtils.styleItalia : StoryUtils.styleOnTheMove}  
    body{
    background-color:${Colors.white};
      margin: 0;
      padding: 0;
    }
    .content_body{
    width: 90% !important;
    margin-left: auto;
    margin-right: auto;
    display: block;
    padding: 20 20px;
    position: relative;
    z-index: 9999;
    } 
    .content_footer{
      position: absolute;
      bottom: 0;
      right: 0;
      z-index: 999999;
    }
    p{color:${Colors.black}; font-size: 16px; }
    h2{color:${Colors.black}; font-size: 24px; font-weight: bold; margin-bottom: 10px;}
    b{color:${Colors.black};}
    div{color:${Colors.black};}
    
    .footer_wraper{
      display: flex;
      justify-content: center;
      background: #fff;
    }
    .footer_logo{
      margin-top:30px;
      margin-bottom: 20px;
      height: 45px;
      weight: 100%;
    }
    .cotent_footer_img{
      height: 120px;
      weight: 100%;
    }
    .content_text{
      margin-bottom:150px;
    }
    
    </style> 
    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
    <body>
    <div class="content_body"> 
      <div><h2>$title</h2></div>
      <div class= "content_text">$content</div>
      <div class="content_footer">
        <img src = "https://storage.googleapis.com/u-report-7f1f3.appspot.com/icon/globe.png"  class="cotent_footer_img"/>
      </div>
     </div>
    <div class="footer_wraper">
      <img src = "${RemoteConfigData.getLargeIcon()}" class="footer_logo"/>
    </div> 
    </body> 
    </html>''';

    webViewController.loadUrl(Uri.dataFromString(final_content,
            mimeType: 'text/html', encoding: Encoding.getByName("UTF-8"))
        .toString());
  }

  getContentOffline(String title, String content) {
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
    <!ECOTYPE html>
    <html> 
    <style>
    ${sp.getValue(SPUtil.PROGRAMKEY) == "Global" ? StoryUtils.styleItalia : sp.getValue(SPUtil.PROGRAMKEY) == "Italia" ? StoryUtils.styleItalia : StoryUtils.styleOnTheMove}  
    body{
    background-color:${RemoteConfigData.getWebBackgroundColor()};
      margin: 0;
      padding: 0;
    }
    .content_body{
    width: 90% !important;
    margin-left: auto;
    margin-right: auto;
    display: block;
    padding: 1 1px;
    position: relative;
    z-index: 9999;
    } 
    .content_footer{
      position: absolute;
      bottom: 0;
      right: 0;
      z-index: 999999;
    }
    p{color:${Colors.black};}
    h2{color:${Colors.black};}
    b{color:${Colors.black};}
    div{color:${Colors.black};}
    
    .footer_wraper{
      display: flex;
      justify-content: center;
      background: #fff;
    }
    .footer_logo{
      margin-top:30px;
      margin-bottom: 20px;
      height: 45px;
      weight: 100%;
    }
    .cotent_footer_img{
      height: 120px;
      weight: 100%;
    }
    .content_text{
      margin-bottom:150px;
    }
    
    </style> 
    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
    <body>
    <div class="content_body"> 
      <div><h2>$title</h2></div>
      <div class= "content_text">$content</div>
     </div>
    </body> 
    </html>''';

    webViewController.loadUrl(Uri.dataFromString(final_content,
            mimeType: 'text/html', encoding: Encoding.getByName("UTF-8"))
        .toString());
  }
}
