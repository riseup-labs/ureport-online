import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/chooser/language_chooser.dart';
import 'package:ureport_ecaro/firebase-remote-config/response-remote-config-data.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class RemoteConfigController extends ChangeNotifier {

  var sp = locator<SPUtil>();

  late ResponseRemoteConfigData remoteConfigData;

  getInitialData(BuildContext context) async {
    RemoteConfig remoteConfig = RemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 3600),
      minimumFetchInterval: Duration(days: 1),
    ));

    await remoteConfig.fetchAndActivate();
    if (remoteConfig.getString("values").isNotEmpty) {
      var firebasedata = remoteConfig.getString("values");
      var data = ResponseRemoteConfigData.fromJson(json.decode(firebasedata));
      remoteConfigData = data;
      sp.setValue(SPConstant.ALL_PROGRAMS, firebasedata);
    }

    notifyListeners();
  }
}
