import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login.dart';
import 'package:ureport_ecaro/all-screens/account/profile/menu_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/profile_view.dart';
import 'package:ureport_ecaro/all-screens/chooser/program_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:ureport_ecaro/all-screens/home/chat/Chat.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'intro_content.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  PageController? _pageController;
  late SPUtil _sp;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentPage);
    _sp = locator<SPUtil>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var region = _sp.getValue(SPConstant.SELECTED_LANGUAGE);

    List<Map<String, String>> splashData = [
      // Different text and image for language romanian
      {
        "text": "${AppLocalizations.of(context)!.stories}",
        "text2": "${AppLocalizations.of(context)!.intro_text1}",
        "image": region == 'ro'
            ? "assets/images/drawable-xxhdpi/v2_about_1_ro.png"
            : "assets/images/drawable-xxhdpi/v2_about_1.png"
      },
      {
        "text": "${AppLocalizations.of(context)!.chat}",
        "text2": "${AppLocalizations.of(context)!.intro_text2}",
        "image": region == 'ro'
            ? "assets/images/drawable-xxhdpi/v2_about_2_ro.png"
            : "assets/images/drawable-xxhdpi/v2_about_2.png"
      },
      {
        "text": "${AppLocalizations.of(context)!.opinions}",
        "text2": "${AppLocalizations.of(context)!.intro_text3}",
        "image": region == 'ro'
            ? "assets/images/into_page_3_ro.png"
            : "assets/images/into_page_3.png"
      },
    ];

    return Scaffold(
      backgroundColor: region == 'ro'
          ? Colors.white
          : currentPage == 0
              ? AppColors.mainBgColor
              : currentPage == 1
                  ? AppColors.mainBgColor2
                  : AppColors.opinion_intro_back,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 0, bottom: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                region == 'ro'
                    ? TopHeaderWidget(
                        title: "Intro",
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    color: region == 'ro'
                        ? Colors.white
                        : currentPage == 0
                            ? AppColors.mainBgColor
                            : currentPage == 1
                                ? AppColors.mainBgColor2
                                : AppColors.mainBgColor3,
                    child: getPageBuilder(0, splashData, region!),
                  ),
                ),
                Container(
                  color: region == 'ro'
                      ? Colors.white
                      : currentPage == 2
                          ? AppColors.opinion_intro_back
                          : null,
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
                            onTap: () {
                              ClickSound.soundClick();
                              NavUtils.pushAndRemoveUntil(
                                  context, ProgramChooser("intro"));
                            },
                            child: Text("${AppLocalizations.of(context)!.skip}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _sp.getValue(
                                                SPConstant.SELECTED_LANGUAGE) ==
                                            'ro'
                                        ? Colors.black
                                        : currentPage != 0
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: getBuildDot(splashData, region),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                ClickSound.soundClick();
                                currentPage++;
                                if (currentPage >= 3) {
                                  NavUtils.pushAndRemoveUntil(
                                      context, ProgramChooser("intro"));
                                } else {
                                  _pageController!.nextPage(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeIn);
                                  setState(() {});
                                }
                              },
                              child: Text(
                                "${AppLocalizations.of(context)!.next}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _sp.getValue(
                                                SPConstant.SELECTED_LANGUAGE) ==
                                            'ro'
                                        ? Colors.black
                                        : currentPage != 0
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBuildDot(List<Map<String, String>> splashData, String region) {
    return List.generate(
      splashData.length,
      (index) => buildDot(index: index, region: region),
    );
  }

  getPageBuilder(
      int page, List<Map<String, String>> splashData, String region) {
    return Stack(
      children: [
        region == 'ro'
            ? SizedBox()
            : Positioned(
                right: 30,
                top: 30,
                child: Container(
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.only(top: 35),
                    child: Image.asset(
                      "assets/images/v2_ic_u.png",
                      fit: BoxFit.fill,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              ),
        Container(
          margin: EdgeInsets.only(top: 40),
          child: PageView.builder(
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
                  key: null,
                  region: region),
              controller: _pageController),
        ),
      ],
    );
  }

  AnimatedContainer buildDot({int? index, required String region}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: region == 'ro'
            ? Colors.black
            : currentPage == index
                ? Colors.black
                : Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
