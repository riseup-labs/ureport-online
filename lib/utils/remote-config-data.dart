import 'dart:convert';

import 'package:ureport_ecaro/firebase-remote-config/response-remote-config-data.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

class RemoteConfigData{

  static getProgramList(){
    List<String> list = [];
    ResponseRemoteConfigData data = getAllData();
    data.programs.forEach((element) {
      list.add(element.name);
    });
    return list;
  }

  static getStoryUrl(String program){
    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if(element.name == program){
        url = element.storyApi;
      }
    });
    return url;
  }

  static getOpinionUrl(String program){
    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if(element.name == program){
        url = element.opinionApi;
      }
    });
    return url;
  }

  static getStoryDetailsUrl(String program){
    String url = "";
    ResponseRemoteConfigData data = getAllData();

    data.programs.forEach((element) {
      if(element.name == program){
        url = element.storyDetailsApi;
      }
    });
    return url;
  }



  static getAllData(){
    var sp = locator<SPUtil>();
    Map<String,dynamic> data = jsonDecode(sp.getValue(SPConstant.ALL_PROGRAMS));
    var values = ResponseRemoteConfigData.fromJson(data);
    return  values;
  }

}