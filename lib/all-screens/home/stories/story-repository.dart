import 'package:ureport_ecaro/all-screens/home/opinions/model/Response_opinions.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';

import 'model/response-story-data.dart';

class StroyRipository {
  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseStories>> getStory( pageno) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.getRequest(ApiConst.RESULT_STORY_BASEURL,qp: {"limit":pageno});
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseStories.fromJson(apiResponse.data.data)
    );
  }
}