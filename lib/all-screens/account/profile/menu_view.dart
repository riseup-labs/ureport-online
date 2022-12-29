import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/about_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/change_pw_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/profile_header_component.dart';
import 'package:ureport_ecaro/all-screens/account/profile/language_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/profile_view.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeaderWidget(title: "Meniu"),
      body: SafeArea(
          child: Column(
        children: [
          ProfileHeaderComponent(),
          Expanded(
            child: ListView(children: [
              menuItem(context, "Despre", AboutScreen()),
              menuItem(context, "Profilul tau", ProfileScreen()),
              menuItem(context, "Schimba programul", null),
              menuItem(context, "Schimba limba", LanguageChooser()),
              menuItem(context, "Schimba parola", ChangePasswordScreen()),
              menuItem(context, "Sterge cont", null),
            ]),
          ),
        ],
      )),
    );
  }

  Widget menuItem(BuildContext context, String title, Widget? widget) {
    return GestureDetector(
      onTap: () => widget != null ? NavUtils.push(context, widget) : {},
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 100,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Color.fromRGBO(253, 209, 243, 1),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
