import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/theme/style.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  var _sp = locator<SPUtil>();

  ThemeProvider(this._themeData);

  ThemeData getThemeData() {
    var darkTheme = _sp.getValue(SPUtil.KEY_DARK_THEME);

    if (darkTheme != null && darkTheme == "1") {
      _themeData = MyThemeData.darkTheme;
    }

    return _themeData;
  }

  setLightTheme() {
    _themeData = MyThemeData.lightTheme;
    _sp.setValue(SPUtil.KEY_DARK_THEME, "0");
    notifyListeners();
  }

  setDarkTheme() {
    _themeData = MyThemeData.darkTheme;
    _sp.setValue(SPUtil.KEY_DARK_THEME, "1");
    notifyListeners();
  }

  toggleTheme() {
    _themeData =
    _themeData == MyThemeData.lightTheme ? MyThemeData.darkTheme : MyThemeData.lightTheme;
    notifyListeners();
  }
}