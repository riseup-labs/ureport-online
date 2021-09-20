import 'package:flutter/material.dart';

class NavUtils {
  static Future<T> push<T>(BuildContext context, Widget screen) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    return result;
  }

  static pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static pushAndRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => screen), (_) => false);
  }
}