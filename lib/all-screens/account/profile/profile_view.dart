import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/history_tab_component.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/medals_tab_component.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/profile_header_component.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            TopHeaderWidget(title: "Profil"),
            ProfileHeaderComponent(),
            Container(
              width: 400,
              height: 100,
              child: TabBar(
                indicatorColor: Color.fromRGBO(253, 209, 243, 1),
                unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
                labelColor: Color.fromRGBO(152, 8, 119, 1),
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: _controller,
                children: [
                  HistoryTabComponent(),
                  MedalsTabComponent(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
