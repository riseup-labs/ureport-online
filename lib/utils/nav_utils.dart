import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/chat/Chat.dart';

class NavUtils {
  static Future<T> push<T>(BuildContext context, Widget screen) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    return result;
  }

  static pushToChat<T>(BuildContext context, String from) async {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => Chat(from),
      // transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   const begin = Offset(0.0, 1.0);
      //   const end = Offset.zero;
      //   const curve = Curves.ease;
      //
      //   var tween =
      //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //   return SlideTransition(
      //     position: animation.drive(tween),
      //     child: child,
      //   );
      // },
    ));
  }

  static pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static pushAndRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => screen),
        (_) => false);
  }
}
