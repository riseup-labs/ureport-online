import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/program_chooser.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'intro_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, String>> splashData = [
      {
        "text": "${AppLocalizations.of(context)!.stories}",
        "text2": "${AppLocalizations.of(context)!.intro_text1}",
        "image": "assets/images/drawable-xxhdpi/intro_1.png"
      },
      {
        "text": "${AppLocalizations.of(context)!.chat}",
        "text2": "${AppLocalizations.of(context)!.intro_text2}",
        "image": "assets/images/drawable-xxhdpi/intro_2.png"
      },
      {
        "text": "${AppLocalizations.of(context)!.opinions}",
        "text2": "${AppLocalizations.of(context)!.intro_text3}",
        "image": "assets/images/drawable-xxhdpi/intro_3.png"
      },
    ];

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                child: getPageBuilder(0,splashData),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          NavUtils.pushAndRemoveUntil(context, ProgramChooser());
                        },
                        child: Text("${AppLocalizations.of(context)!.skip}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey[600])),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: getBuildDot(splashData),
                      ),
                      GestureDetector(
                          onTap: () {
                            currentPage++;
                            if (currentPage >= 3) {
                              NavUtils.pushAndRemoveUntil(context, ProgramChooser());
                            }else{
                              _pageController!.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                              setState(() {});
                            }
                          },
                          child: Text(
                            "${AppLocalizations.of(context)!.next}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue[300]),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBuildDot(List<Map<String, String>> splashData) {
    return List.generate(
      splashData.length,
      (index) => buildDot(index: index),
    );
  }

  getPageBuilder(int page,List<Map<String, String>> splashData) {
    return PageView.builder(
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      itemCount: splashData.length,
      itemBuilder: (context, index) => SplashContent(
        image: splashData[index]["image"]!,
        text: splashData[index]['text']!,
        text2: splashData[index]['text2']!,
        // ignore: null_check_always_fails
        key: null,
      ),
      controller: _pageController
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? AppColors.primary : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
