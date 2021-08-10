import 'package:flutter/material.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
      fontFamily: 'Heebo',
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent));

  static ThemeData darkTheme = ThemeData(
      fontFamily: 'Heebo',
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.black54,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent));
}
