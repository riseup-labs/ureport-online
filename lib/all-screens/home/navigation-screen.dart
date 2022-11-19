import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_list.dart';
import 'package:ureport_ecaro/all-screens/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';

import 'chat/Chat.dart';
import 'opinion/opinion_screen.dart';

class NavigationScreen extends StatefulWidget {
  int changedIndex;
  final String? region;

  NavigationScreen(this.changedIndex, this.region);

  @override
  _NavigationScreenState createState() => _NavigationScreenState(changedIndex);
}

class _NavigationScreenState extends State<NavigationScreen> {
  int changedIndex;

  _NavigationScreenState(this.changedIndex);

  late List<Widget> tabs;

  @override
  void initState() {
    print("??? ${widget.region}");
    if (widget.region == 'ro') {
      tabs = [StoryList()];
    } else {
      tabs = [StoryList(), SizedBox(), Opinion(), Settings()];
      getfirebaseonApp(context);
    }

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
              icon: Image.asset(
                "assets/images/ic_stories.png",
                height: 40.18,
                width: 33.66,
              ),
              activeIcon: Image.asset(
                "assets/images/ic_stories_on.png",
                height: 40.18,
                width: 33.66,
                color: widget.region == 'ro'
                    ? Color.fromRGBO(248, 149, 220, 1)
                    : RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.stories}",
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(left: 5),
                child: Image.asset("assets/images/ic_chat.png",
                    height: 40.18, width: 33.66),
              ),
              activeIcon: Image.asset(
                "assets/images/ic_chat_on.png",
                height: 40.18,
                width: 33.66,
                color: widget.region == 'ro'
                    ? Color.fromRGBO(248, 149, 220, 1)
                    : RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.chat}",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_opinions.png",
                  height: 40.18, width: 33.66),
              activeIcon: Image.asset(
                "assets/images/ic_opinions_on.png",
                height: 40.18,
                width: 33.66,
                color: widget.region == 'ro'
                    ? Color.fromRGBO(248, 149, 220, 1)
                    : RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.opinions}",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_more.png",
                  height: 40.18, width: 33.66),
              activeIcon: Image.asset(
                "assets/images/ic_more_on.png",
                height: 40.18,
                width: 33.66,
                color: widget.region == 'ro'
                    ? Color.fromRGBO(248, 149, 220, 1)
                    : RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.more}",
            ),
          ],
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: widget.region == 'ro'
              ? Color.fromRGBO(248, 149, 220, 1)
              : RemoteConfigData.getPrimaryColor(),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          unselectedItemColor: Colors.black,
          onTap: (int i) {
            ClickSound.soundClick();
            setState(() {
              if (i == 1) {
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
      print("Navigation screen called");
      if (remoteMessage != null) {
        NavUtils.pushReplacement(context, Chat("notification"));
      }
    });
  }
}
