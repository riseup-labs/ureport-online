
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';


import 'api_response.dart';

import 'apicall_responsedata/response_contact_creation.dart';
import 'http_service.dart';
import 'package:http/http.dart' as http;

class RapidProService {

  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseContactCreation>> createContact(String urn,
      String fcmtoken, {@required onSuccess(String uuid)?, @required onError(
          Exception error)?,}) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.postRequesturlencoded(
        "https://${ApiConst.SERVER_LIVE}/c/fcm/${ApiConst.CHANEL_LIVE}/register", data: {
      "urn": urn,
      "fcm_token": fcmtoken,
    }, isurlEncoded: true);
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseContactCreation.fromJson(apiResponse.data.data)
    );
  }



  runflow( contact)async{
    
    await _httpService.getRequest("https://${ApiConst.SERVER_LIVE}/api/v2/contacts.json",qp:{"uuid":contact}).then((value)async {

      var contactUuid =value.data;
      print("runflow falue ${contactUuid.data['results'][0]['uuid']}");


      await _httpService.postRequesturlencoded("https://${ApiConst.SERVER_LIVE}/api/v2/flow_starts.json",data: {
        "flow": "302595c7-d273-477f-9a96-b91e65923d82",
        "contacts":[contact]
      }).then((value) {

        print("thee start value is ${value.data}");

      });

    });
  }


  startflow(@required String flow,String contact,@required onSuccess(response),@required onError(error))async{

    await _httpService.postRequesturlencoded("https://${ApiConst.SERVER_LIVE}/api/v2/flow_starts.json",data: {
      "flow": "302595c7-d273-477f-9a96-b91e65923d82",
      "contacts":[contact]
    }).then((value) {
      onSuccess(value.data);
    }).onError((error, stackTrace) {
      onError(error);

    });

  }


  getFlowid(usercontatct) async {
    await _httpService.getRequest("https://${ApiConst.SERVER_LIVE}/api/v2/runs.json",
        qp: {"contact": usercontatct}).then((value) async {
      var contatct = value.data;
      print("this is the flow =${contatct.data['results'][0]['start']["uuid"]}");
    });
  }


  sendMessage({
    @required String? message,
    @required onSuccess(value)?,
    @required onError(Exception value)?,
    urn,
    fcmToken
  }) async {

    print("--------------------------------------message method is called");
     await _httpService.postRequesturlencoded(
        "https://${ApiConst.SERVER_LIVE}/c/fcm/${ApiConst.CHANEL_LIVE}/receive", data: {
      "from": urn,
      "fcm_token": fcmToken,
      "msg": message
    }, isurlEncoded: true).then((value){
      onSuccess!(value.data);
     });

  /*  await http.post(Uri.parse("https://${ApiConst.SERVER}/c/fcm/${ApiConst.CHANEL}/receive"), headers: {
      "Authorization": "Token ${ApiConst.WORKSPACETOKEN}",
    }, body: {
      "from": urn,
      "fcm_token": fcmToken,
      "msg": message
    }).then((value) {
      onSuccess!(value.body);
    }).catchError((e) {
      onError!(e);
    });*/
  }
/*  register({@required onSuccess(String uuid)?, @required onError(Exception error)?,}) async {
    await http.post("https://$server/c/fcm/$channel/register", body: {
      "urn": urn,
      "fcm_token": fcmToken,
      "name": namethen((value) async {
    print(value.body);
    var data = await jsonDecode(value.body);
    contact = await data['contact_uuid'];
    print("the contact is================ $contact");
    }).
      return onSuccess(data['contact_uuid']);
    }).catchError((e) => onError(e));
  }*/
}
