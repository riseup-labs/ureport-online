import 'package:ureport_ecaro/all-screens/home/stories/model/response-story-details.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/api_response.dart';
import 'package:ureport_ecaro/network_operation/http_service.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';

import 'model/response-story-data.dart';

class StroyRipository {
  var _httpService = locator<HttpService>();

  Future<ApiResponse<ResponseStories>> getStory(String url) async {
    var apiResponse = await _httpService.getRequest(url);
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseStories.fromJson(apiResponse.data.data));
  }

  Future<ApiResponse<ResponseStoryDetails>> getStoryDetails(String url) async {
    //print("the fcm token is ===$fcmtoken");
    var apiResponse = await _httpService.getRequest(url);
    return ApiResponse(
        httpCode: apiResponse.httpCode,
        message: apiResponse.message,
        data: ResponseStoryDetails.fromJson(apiResponse.data.data));
  }
}
