import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/about_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/change_pw_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/components/profile_header_component.dart';
import 'package:ureport_ecaro/all-screens/account/profile/language_view.dart';
import 'package:ureport_ecaro/all-screens/account/profile/profile_view.dart';
import 'package:ureport_ecaro/all-screens/chooser/program_chooser.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:ureport_ecaro/all-screens/settings/about/about.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeaderWidget(title: "Meniu"),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ProfileHeaderComponent(),
            ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  menuItem(context, "Despre",
                      () => NavUtils.push(context, AboutScreen())),
                  menuItem(context, "Profilul tau",
                      () => NavUtils.push(context, ProfileScreen())),
                  menuItem(context, "Schimba programul",
                      () => NavUtils.push(context, ProgramChooser())),
                  menuItem(context, "Schimba limba",
                      () => NavUtils.push(context, LanguageChooser())),
                  menuItem(context, "Schimba parola",
                      () => NavUtils.push(context, ChangePasswordScreen())),
                  menuItem(context, "Părăsește cont", () {
                    var spset = locator<SPUtil>();

                    ClickSound.soundClick();

                    FirebaseAuth.instance.signOut();
                    spset.deleteKey(SPUtil.PROGRAMKEY);
                    spset.deleteKey(SPConstant.SELECTED_LANGUAGE);
                    NavUtils.pushAndRemoveUntil(context, LanguageChooser());
                  }),
                  menuItem(context, "Sterge cont", null),
                ]),
          ],
        ),
      )),
    );
  }
  /*
     region != null && region!.toLowerCase().startsWith('ro')
                    ? GestureDetector(
                        onTap: () {
                          var spset = locator<SPUtil>();

                          ClickSound.soundClick();

                          FirebaseAuth.instance.signOut();
                          spset.deleteKey(SPUtil.PROGRAMKEY);
                          spset.deleteKey(SPConstant.SELECTED_LANGUAGE);
                          NavUtils.pushAndRemoveUntil(
                              context, LanguageChooser());
                        },
                        child: getItem(
                            "Ieși din cont", "assets/images/v2_ic_program.png"),
                      )
                    : SizedBox(),
  */

  Widget menuItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 100,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Color.fromRGBO(28, 171, 226, 1),
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
