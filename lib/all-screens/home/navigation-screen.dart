import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_list.dart';
import 'package:ureport_ecaro/all-screens/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';

import 'chat/Chat.dart';
import 'chat/chat-controller.dart';
import 'opinion/opinion_screen.dart';

class NavigationScreen extends StatefulWidget {

  int changedIndex;
  NavigationScreen(this.changedIndex);

  @override
  _NavigationScreenState createState() => _NavigationScreenState(changedIndex);
}

class _NavigationScreenState extends State<NavigationScreen> {
  int changedIndex;

  _NavigationScreenState(this.changedIndex);

  final tabs = [StoryList(), Chat(), Opinion(), Settings()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.stories}",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_chat.png",
                  height: 40.18, width: 33.66),
              activeIcon: Image.asset(
                "assets/images/ic_chat_on.png",
                height: 40.18,
                width: 33.66,
                color: RemoteConfigData.getPrimaryColor(),
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
                color: RemoteConfigData.getPrimaryColor(),
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
                color: RemoteConfigData.getPrimaryColor(),
              ),
              label: "${AppLocalizations.of(context)!.more}",
            ),
          ],
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: RemoteConfigData.getPrimaryColor(),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          unselectedItemColor: Colors.black,
          onTap: (int i) {
            ClickSound.buttonClickYes();
            setState(() {
              changedIndex = i;
              i++;
            });
          },
        ));
  }
}
