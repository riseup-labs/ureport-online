import 'package:flutter/material.dart';

class ShowSnackBar{

  static showNoInternetMessage(context){
    final snackBar = SnackBar(content: Text('No internet connection available'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}