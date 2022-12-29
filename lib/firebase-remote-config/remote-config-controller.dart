import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ureport_ecaro/firebase-remote-config/response-remote-config-data.dart';
import 'package:ureport_ecaro/firebase_options.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class RemoteConfigController extends ChangeNotifier {
  var sp = locator<SPUtil>();

  late ResponseRemoteConfigData remoteConfigData;

  getInitialData(BuildContext context) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 10),
    ));
    await remoteConfig.ensureInitialized();

    await remoteConfig.fetchAndActivate();

    if (remoteConfig.getString("ureport_data_v2").isNotEmpty) {
      var firebasedata = remoteConfig.getString("ureport_data_v2");
      var data = ResponseRemoteConfigData.fromJson(json.decode(firebasedata));
      remoteConfigData = data;
      sp.setValue(SPConstant.ALL_PROGRAMS, firebasedata);
    }

    notifyListeners();
  }
}
