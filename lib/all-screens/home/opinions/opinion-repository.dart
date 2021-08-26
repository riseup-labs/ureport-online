import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';

import 'model/Response_opinions.dart';

class OpinionRepository {
  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseOpinions>> getOpinions( pageno) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.getRequest(ApiConst.RESULT_OPINION_BASEURL,qp: {"limit":pageno});
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseOpinions.fromJson(apiResponse.data.data)
    );
  }

}