
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/response-story-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';

class StoryDetailsController extends ConnectivityController{

  var _storyservice = locator<StroyRipository>();
  var webviewHeight = 1;

  ResponseStoryDetails? responseStoryDetails ;

  getStoriesDetailsFromRemote(String url) async {
    var apiresponsedata = await _storyservice.getStoryDetails(url);
    if(apiresponsedata.httpCode==200){
      responseStoryDetails = apiresponsedata.data;
      notifyListeners();
    }
  }

}