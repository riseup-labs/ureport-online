import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';

import 'model/response_about.dart';

class AboutRepository{

  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseAbout>> getAbout(String url) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.getRequest(url);
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseAbout.fromJson(apiResponse.data.data)
    );
  }
}