import 'package:flutter/material.dart';

import 'click_sound.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowSnackBar{

  static showNoInternetMessage(context){
    final snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.no_internet_text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    ClickSound.soundNoInternet();
  }


}