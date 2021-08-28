import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_list.dart';
import 'package:ureport_ecaro/all-screens/settings/settings.dart';
import 'package:ureport_ecaro/utils/resources.dart';

import 'chat/Chat.dart';
import 'opinions/opinions-screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  final tabs = [
    StoryList(),
    Chat(),
    OpinionsScreen(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: _currentIndex, children: tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/ic_stories.png",
                height: 45.18,
                width: 40.66,
              ),
              activeIcon: Image.asset(
                "assets/images/ic_stories_on.png",
                height: 45.18,
                width: 40.66,
              ),
              label: "Stories",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_chat.png",
                  height: 45.18, width: 40.66),
              activeIcon: Image.asset(
                "assets/images/ic_chat_on.png",
                height: 45.18,
                width: 40.66,
              ),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_opinions.png",
                  height: 45.18, width: 40.66),
              activeIcon: Image.asset(
                "assets/images/ic_opinions_on.png",
                height: 45.18,
                width: 40.66,
              ),
              label: "Opinions",
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_more.png",
                  height: 45.18, width: 40.66),
              activeIcon: Image.asset(
                "assets/images/ic_more_on.png",
                height: 45.18,
                width: 40.66,
              ),
              label: "More",
            ),
          ],
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedItemColor: Color(0xff41B6E6),
          unselectedItemColor: Colors.black,
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
              i++;
            });
          },
        ));
  }
}
