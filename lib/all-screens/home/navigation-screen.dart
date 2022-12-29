import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login.dart';
import 'package:ureport_ecaro/all-screens/account/profile/profile_view.dart';
import 'package:ureport_ecaro/all-screens/home/articles/categories/category_list.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_list.dart';
import 'package:ureport_ecaro/all-screens/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'chat/Chat.dart';
import 'opinion/opinion_screen.dart';

class NavigationScreen extends StatefulWidget {
  int changedIndex;
  final String? region;

  NavigationScreen(
    this.changedIndex,
    this.region,
  );

  @override
  _NavigationScreenState createState() => _NavigationScreenState(changedIndex);
}

class _NavigationScreenState extends State<NavigationScreen> {
  int changedIndex;

  _NavigationScreenState(this.changedIndex);

  late List<Widget> tabs;
  List<BottomNavigationBarItem> bottomNavItems = [];

  @override
  void initState() {
    var spset = locator<SPUtil>();

    if (spset.getValue(SPUtil.PROGRAMKEY) != null &&
        spset.getValue(SPUtil.PROGRAMKEY)!.toLowerCase().startsWith('ro')) {
      tabs = [
        CategoryListScreen(),
        SizedBox(),
        SizedBox(),
        Opinion(),
        ProfileScreen()
      ];
    } else {
      tabs = [StoryList(), SizedBox(), Opinion(), Settings()];
    }

    getfirebaseonApp(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0.0,
        ),
        body: IndexedStack(index: changedIndex, children: tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: changedIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.article_outlined,
                      color: RemoteConfigData.getPrimaryColor())
                  : Image.asset(
                      "assets/images/ic_stories.png",
                      height: 40.18,
                      width: 33.66,
                    ),
              activeIcon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.article,
                      color: RemoteConfigData.getPrimaryColor())
                  : Image.asset(
                      "assets/images/ic_stories_on.png",
                      height: 40.18,
                      width: 33.66,
                      color: RemoteConfigData.getPrimaryColor(),
                    ),
              label: "${AppLocalizations.of(context)!.stories}",
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(left: 5),
                child: widget.region!.toLowerCase().startsWith('ro')
                    ? Icon(Icons.chat_outlined,
                        color: RemoteConfigData.getPrimaryColor())
                    : Image.asset("assets/images/ic_chat.png",
                        height: 40.18, width: 33.66),
              ),
              activeIcon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.chat, color: RemoteConfigData.getPrimaryColor())
                  : Image.asset(
                      "assets/images/ic_chat_on.png",
                      height: 40.18,
                      width: 33.66,
                      color: RemoteConfigData.getPrimaryColor(),
                    ),
              label: "${AppLocalizations.of(context)!.chat}",
            ),
            if (widget.region!.toLowerCase().startsWith('ro'))
              BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Icon(Icons.home_outlined,
                        color: RemoteConfigData.getPrimaryColor())),
                activeIcon:
                    Icon(Icons.home, color: RemoteConfigData.getPrimaryColor()),
                label: "Home",
              ),
            BottomNavigationBarItem(
              icon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(
                      Icons.bar_chart_outlined,
                      color: RemoteConfigData.getPrimaryColor(),
                    )
                  : Image.asset("assets/images/ic_opinions.png",
                      height: 40.18, width: 33.66),
              activeIcon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.bar_chart,
                      color: RemoteConfigData.getPrimaryColor())
                  : Image.asset(
                      "assets/images/ic_opinions_on.png",
                      height: 40.18,
                      width: 33.66,
                      color: RemoteConfigData.getPrimaryColor(),
                    ),
              label: "${AppLocalizations.of(context)!.opinions}",
            ),
            BottomNavigationBarItem(
              icon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.menu_outlined,
                      color: RemoteConfigData.getPrimaryColor())
                  : Image.asset("assets/images/ic_more.png",
                      height: 40.18, width: 33.66),
              activeIcon: widget.region!.toLowerCase().startsWith('ro')
                  ? Icon(Icons.menu, color: RemoteConfigData.getPrimaryColor())
                  : Image.asset(
                      "assets/images/ic_more_on.png",
                      height: 40.18,
                      width: 33.66,
                      color: RemoteConfigData.getPrimaryColor(),
                    ),
              label: "${AppLocalizations.of(context)!.more}",
            ),
          ],
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: widget.region!.toLowerCase().startsWith('ro')
              ? Colors.black
              : RemoteConfigData.getPrimaryColor(),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          unselectedItemColor: Colors.black,
          onTap: (int i) {
            ClickSound.soundClick();
            setState(() {
              if (i == 1 && widget.region!.toLowerCase().startsWith('ro')) {
                NavUtils.pushToChat(context, "Home");
              } else {
                changedIndex = i;
              }
            });
          },
        ));
  }

  getfirebaseonApp(context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        NavUtils.pushReplacement(context, Chat("notification"));
      }
    });
  }
}
