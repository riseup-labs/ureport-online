import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/profile_header_component.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          TopHeaderWidget(title: "Meniu"),
          ProfileHeaderComponent(),
        ],
      )),
    );
  }
}
