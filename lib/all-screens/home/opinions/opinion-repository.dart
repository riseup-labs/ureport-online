import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/Response_opinions.dart';

class OpinionRepository {
  var _httpService = locator<HttpService>();
  var spservice =locator<SPUtil>();

  Future<ApiResponse<ResponseOpinions>> getOpinions( pageno) async {



    var apiResponse = await _httpService.getRequest(ApiConst.RESULT_OPINION_BASEURL,qp: {"limit":pageno});

    if(apiResponse.data.data!=null){
      String makeoffline=jsonEncode(apiResponse.data.data);
      spservice.setValue( SPUtil.OPINIONDATA, makeoffline);
    }
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseOpinions.fromJson(apiResponse.data.data)
    );


  }


  Future<ApiResponse<ResponseOpinions>> getOpinionsoffline() async {

    String offlinedata = spservice.getValue(SPUtil.OPINIONDATA);
    Map<String , dynamic> offlinemapdata= jsonDecode(offlinedata);
    return ApiResponse(
        httpCode: 200,
        message:"success",
        data: ResponseOpinions.fromJson(offlinemapdata)
    );
  }

}