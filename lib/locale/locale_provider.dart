import 'package:flutter/material.dart';
import 'package:ureport_ecaro/l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void setInitialLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}