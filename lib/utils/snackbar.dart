import 'package:flutter/material.dart';

import 'click_sound.dart';

class ShowSnackBar{

  static showNoInternetMessage(context){
    final snackBar = SnackBar(content: Text('No internet connection is available'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    ClickSound.soundNoInternet();
  }


}