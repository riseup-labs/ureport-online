import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/loading_bar.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
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
    // TODO: implement initState
    super.initState();
    Provider.of<AboutController>(context, listen: false).aboutData = null;
    Provider.of<AboutController>(context, listen: false).getAboutFromRemote(RemoteConfigData.getAboutUrl(sp.getValue(SPUtil.PROGRAMKEY)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutController>(builder: (context, provider, child){
      return SafeArea(
        child: Scaffold(
          body: Container(
            color: RemoteConfigData.getBackgroundColor(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 80,
                    child: Image(
                      height: 35,
                      width: 35,
                      color:  RemoteConfigData.getTextColor(),
                      image: AssetImage("assets/images/v2_ic_back.png"),
                    ),
                  ),
                ),
                Container(
                  child: provider.aboutData!= null?Expanded(
                    child: WebViewPlus(
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                        controller.webViewController.clearCache();
                        // loadData();
                        getContent(provider.aboutData!.results[0].title,provider.aboutData!.results[0].content);
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
                  ):Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: LoadingBar.spinkit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    );
  }

  getContent(String title, String content){

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

    String final_content = '''
    <html> 
    <style>  
    body{width: 80% !important;margin-left: auto;margin-right: auto;display: block;margin-top:10px;margin-bottom:10px; background-color:${RemoteConfigData.getWebBackgroundColor()};} 
    p{color:${RemoteConfigData.getWebTextColor()};}
    h2{color:${RemoteConfigData.getWebTextColor()};}
    b{color:${RemoteConfigData.getWebTextColor()};}
    div{color:${RemoteConfigData.getWebTextColor()};}
    </style> 
    <body> 
    <div><h2>$title</h2></div>
    <div>$content</div> 
    </body> 
    </html>''';

    webViewController.loadUrl(Uri.dataFromString(final_content,
        mimeType: 'text/html',
        encoding: Encoding.getByName("UTF-8"))
        .toString());
  }
}

