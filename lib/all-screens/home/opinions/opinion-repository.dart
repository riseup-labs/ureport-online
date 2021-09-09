import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/Response_opinions.dart';
import 'model/Response_opinions.dart' as quistionlist;

class OpinionRepository {
  var _httpService = locator<HttpService>();
  var spservice =locator<SPUtil>();
  var sp = locator<SPUtil>();


  Future<ApiResponse<ResponseOpinions>> getOpinions(String url) async {

    var apiResponse = await _httpService.getRequest(url);

    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseOpinions.fromJson(apiResponse.data.data)
    );

  }

  Future<ApiResponse<List<quistionlist.Question>>> getOpinionsoffline(quistionlistFromlocal) async {

    final mapdata=jsonDecode(quistionlistFromlocal);

    List<quistionlist.Question> d =(mapdata as List).map((e) => quistionlist.Question.fromJson(e)).toList();




/*    List<quistionlist.Question> quistionlistdata = List.empty(growable: true);
    (jsonDecode(quistionlistFromlocal) as List).forEach((element) {
      quistionlistdata.add(quistionlist.Question.fromJson(element));
    });*/

    return ApiResponse(
        httpCode: 200,
        message:"success",
        data:d
    );
  }

}