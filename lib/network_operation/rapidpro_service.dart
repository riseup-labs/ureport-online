
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';


import 'api_response.dart';

import 'apicall_responsedata/response_contact_creation.dart';
import 'apicall_responsedata/response_single_contact.dart';
import 'apicall_responsedata/response_startflow.dart';
import 'http_service.dart';
import 'package:http/http.dart' as http;

class RapidProService {


  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseContactCreation>> createContact(String urn,
      String fcmtoken,String name,{@required onSuccess(String uuid)?, @required onError(
          Exception error)?,}) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.postRequesturlencoded(
        "https://${ApiConst.SERVER_OFFICIAL}/c/fcm/${ApiConst
            .CHANEL_OFFICIAL}/register", data: {
      "urn": urn,
      "fcm_token": fcmtoken,
      "name": name,
    }, isurlEncoded: true);
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseContactCreation.fromJson(apiResponse.data.data)
    );
  }


  Future<ApiResponse<ResponseSingleContact>> getSingleContact(contact) async {
    var apiResponse = await _httpService.getRequest(
        "https://${ApiConst.SERVER_LIVE}/api/v2/contacts.json",
        qp: {"uuid": contact});
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseSingleContact.fromJson(apiResponse.data.data)
    );
  }


  Future<ApiResponse<ResponseStartflow>> startflow(String flow,
      String urn) async {
    print("the urn is ${urn}");

    var apiResponse = await _httpService.postRequesturlencoded(
        "https://${ApiConst.SERVER_LIVE}/api/v2/flow_starts.json", data: {
      "flow": flow,
      "urns": "$urn"
    });

    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseStartflow.fromJson(apiResponse.data.data)
    );
  }

  startRunflow(usercontatct) async {
    await _httpService.getRequest(
        "https://${ApiConst.SERVER_LIVE}/api/v2/runs.json",
        qp: {"contact": usercontatct}).then((value) async {
      var contatct = value.data;
      startflow(contatct.data['results'][0]['flow']['uuid'],
          contatct.data['results'][0]['contact']['urn']);
      print("this is the flow =${contatct.data['results'][0]['flow']["uuid"]}");
    });
  }

  sendMessage({@required String? message, @required onSuccess(
      value)?, @required onError(Exception value)?, urn, fcmToken
  }) async {
    await _httpService.postRequesturlencoded(
      "https://${ApiConst.SERVER_OFFICIAL}/c/fcm/${ApiConst.CHANEL_OFFICIAL}/receive",
      data: {
        "from": urn,
        "fcm_token": fcmToken,
        "msg": message
      },).then((value) {
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


  sendMessagetypehttp({@required String? message, @required onSuccess(
      value)?, @required onError(Exception value)?, urn, fcmToken}) async
  {
    await http.post(Uri.parse("https://${ApiConst.SERVER_LIVE}/c/fcm/${ApiConst
        .CHANEL_LIVE}/receive"), headers: {
      "Authorization": "Token ${ApiConst.WORKSPACETOKEN_LIVE}",
    }, body: {
      "from": urn,
      "fcm_token": fcmToken,
      "msg": message
    }).then((value) {
      onSuccess!(value.body);
    }).catchError((e) {
      onError!(e);
    });
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
