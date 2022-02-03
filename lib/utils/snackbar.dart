import 'package:flutter/material.dart';

import 'click_sound.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowSnackBar{

  static showNoInternetMessage(context){
    final snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.no_internet_text,style: TextStyle(fontSize: 16),),duration: Duration(milliseconds: 1500),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    ClickSound.soundNoInternet();
  }

  static showNoInternetMessageChat(context){
    final snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.no_internet_text, style: TextStyle(fontSize: 16)),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      margin: EdgeInsets.only(bottom: 65),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    ClickSound.soundNoInternet();
  }


}