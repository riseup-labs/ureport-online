
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/locator/locator.dart';


import 'model/response-story-data.dart';
import 'model/response-story-data.dart' as storyarray;

class StoryController extends ChangeNotifier{

  var _storyservice = locator<StroyRipository>();
    ResponseStories? responseStoriesData;

    bool _isloading= false;


  bool get isloading => _isloading;
  var pageSize=1;

  PagingController<int, storyarray.Result> pagingController = PagingController(firstPageKey: 1);
  List<storyarray.Result> items = List.empty(growable: true);

  addPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      getStories(pageKey);
    });
  }

  set isloading(bool value) {
    _isloading = value;
  }

  getStories(int pageno) async {
    _isloading=true;
    var apiresponsedata = await _storyservice.getStory("${pageno}");
    if(apiresponsedata.httpCode==200){
      responseStoriesData=apiresponsedata.data;
      items.clear();
      final isLastPage = apiresponsedata.data.results.length < pageSize;
      items.addAll(apiresponsedata.data.results);

      if (isLastPage) {
        pagingController.appendLastPage(apiresponsedata.data.results);
      } else {
        final nextPageKey = pageno + 1;
        pagingController.appendPage(apiresponsedata.data.results, nextPageKey);
      }

      _isloading=false;
    }
    notifyListeners();
  }

}