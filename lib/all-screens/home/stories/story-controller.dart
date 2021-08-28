
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/response-story-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'model/ResponseStoryLocal.dart';
import 'model/response-story-data.dart' as storyarray;

class StoryController extends ChangeNotifier{

  var _storyservice = locator<StroyRipository>();

  bool _isloading= false;
  bool get isloading => _isloading;
  int listSize = 0;

  set isloading(bool value) {
    _isloading = value;
  }

  List<storyarray.Result> items = List.empty(growable: true);
  ResponseStoryDetails? responseStoryDetails ;
  DatabaseHelper _databaseHelper = DatabaseHelper();

  getStoriesFromRemote(String url) async {
    var apiresponsedata = await _storyservice.getStory(url);
    if(apiresponsedata.httpCode==200){
      items.addAll(apiresponsedata.data.results);
      if(apiresponsedata.data.next != null){
        getStoriesFromRemote(apiresponsedata.data.next);
      }else{
        _databaseHelper.insertStory(items);
        notifyListeners();
        _isloading=false;
      }
    }
  }

  getStoriesDetailsFromRemote(String url) async {
    var apiresponsedata = await _storyservice.getStoryDetails(url);
    if(apiresponsedata.httpCode==200){
      responseStoryDetails = apiresponsedata.data;
      notifyListeners();
    }
  }

  getStoriesFromLocal() {
    return _databaseHelper.getStories();

  }


  initializeDatabase(){
    _databaseHelper.initializeDatabase().then((value) {
      print('------database intialized');
    });
  }
}