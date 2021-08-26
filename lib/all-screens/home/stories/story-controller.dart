
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/locator/locator.dart';


import 'model/response-story-data.dart';

class StoryController extends ChangeNotifier{

  var _storyservice = locator<StroyRipository>();
    ResponseStories? responseStoriesData;

    bool _isloading= false;


  bool get isloading => _isloading;

  set isloading(bool value) {
    _isloading = value;
  }

  getStories() async {
    _isloading=true;
    var apiresponsedata = await _storyservice.getStory("10");
    if(apiresponsedata.httpCode==200){
      responseStoriesData=apiresponsedata.data;
      _isloading=false;
    }
    notifyListeners();
  }

}