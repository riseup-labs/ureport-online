import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/history_widget.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/medal_widget.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/profile_header_component.dart';
import 'package:ureport_ecaro/all-screens/account/profile/model/history.dart';
import 'package:ureport_ecaro/all-screens/account/profile/model/medal.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

  final List<Medal> medalsList = [
    Medal(
        id: 1,
        image:
            "https://www.iconpacks.net/icons/1/free-medal-icon-1369-thumb.png",
        title: "Medal title",
        description: "Short description medal",
        isActive: true),
    Medal(
        id: 1,
        image:
            "https://www.iconpacks.net/icons/1/free-medal-icon-1369-thumb.png",
        title: "Medal title",
        description: "Short description medal",
        isActive: true),
    Medal(
        id: 1,
        image:
            "https://www.iconpacks.net/icons/1/free-medal-icon-1369-thumb.png",
        title: "Medal title",
        description: "Short description medal",
        isActive: true),
    Medal(
        id: 1,
        image:
            "https://www.iconpacks.net/icons/1/free-medal-icon-1369-thumb.png",
        title: "Medal title",
        description: "Short description medal",
        isActive: true),
    Medal(
        id: 1,
        image:
            "https://www.iconpacks.net/icons/1/free-medal-icon-1369-thumb.png",
        title: "Medal title",
        description: "Short description medal",
        isActive: true),
  ];

  List<History> historyList = [
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
    History(
        id: 1,
        image: "https://cdn-icons-png.flaticon.com/128/993/993504.png",
        topic: "SANATATE",
        title: "Titlu topic"),
  ];

  @override
  void initState() {
    _controller = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeaderWidget(title: "Profil"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            ProfileHeaderComponent(),
            Container(
              width: 400,
              height: 100,
              child: TabBar(
                indicatorColor: Color.fromRGBO(68, 151, 223, 1),
                unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
                labelColor: Color.fromRGBO(68, 151, 223, 1),
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                controller: _controller,
                tabs: [
                  Text("Istoric"),
                  Text(
                    "Medalii",
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: _controller,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: medalsList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HistoryWidget(
                        history: historyList[index],
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: medalsList.length,
                    itemBuilder: (context, index) => MedalWidget(
                      medal: medalsList[index],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
