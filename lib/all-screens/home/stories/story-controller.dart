import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/response-story-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/save_story.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/load_data_handling.dart';
import 'model/ResponseStoryLocal.dart';
import 'model/response-story-data.dart' as storyarray;

class StoryController extends ConnectivityController {
  var _storyservice = locator<StroyRipository>();

  var noResultFound = false;
  bool isLoaded = true;

  var isLoading = false;
  var isSyncing = false;

  setLoading() {
    isLoading = true;
    notifyListeners();
  }
  setSyncing() {
    isSyncing = true;
    notifyListeners();
  }

  List<storyarray.Result> items = List.empty(growable: true);
  DatabaseHelper _databaseHelper = DatabaseHelper();

  getStoriesFromRemote(String url, String program) async {

    var apiresponsedata = await _storyservice.getStory(url);
    if (apiresponsedata.httpCode == 200) {
      items.addAll(apiresponsedata.data.results);
      if (apiresponsedata.data.next != null) {
        getStoriesFromRemote(apiresponsedata.data.next, program);
      } else {
        await _databaseHelper.insertStory(items, program);
        items.forEach((element) {
          StorageUtil.writeStory(element.content, "${program}_${element.id}");
        });
        LoadDataHandling.storeStoryLastUpdate();
        isLoading = false;
        isSyncing = false;
        notifyListeners();
      }
    } else {
      isLoading = false;
      isSyncing = false;
      notifyListeners();
    }
  }

  getStoriesFromLocal(String program) {
    return _databaseHelper.getStories(program);
  }

  getRecentStory(String url, String program) {
    _databaseHelper.getRecentStory(program).then((value) => {
          if (value.length != 0)
            {
              fetchFirstStoryFromRemote(url, program, value[0].id)
            }
          else
            {
              setLoading(),
              getStoriesFromRemote(url, program)
            }
        });
  }

  fetchFirstStoryFromRemote(String url, String program, int id) async {
    var apiresponsedata = await _storyservice.getStory(url + "?limit=1");

    if (apiresponsedata.httpCode == 200) {
      if (apiresponsedata.data.results[0].id != id) {
        getStoriesFromRemote(url, program);
      }else{
        isLoading = false;
        isSyncing = false;
        notifyListeners();
      }
    } else {
      isLoading = false;
      isSyncing = false;
      notifyListeners();
    }
  }

  getCategories(String program) {
    return _databaseHelper.getStoryCategories(program);
  }

  clearStoriesTable() {
    _databaseHelper.deleteStoryTable();
  }

  initializeDatabase() {
    _databaseHelper.initializeDatabase();
  }
}
