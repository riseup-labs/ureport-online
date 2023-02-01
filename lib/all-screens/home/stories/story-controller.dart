import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/response-story-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/save_story.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-repository.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/load_data_handling.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/ResponseStoryLocal.dart';
import 'model/response-story-data.dart' as storyarray;

class StoryController extends ConnectivityController {
  var _storyservice = locator<StroyRipository>();
  var sp = locator<SPUtil>();

  var itemCount = 0;

  var noResultFound = false;
  bool isLoaded = true;

  var isLoading = false;
  var nextLoading = false;
  var isSyncing = false;

  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  setNextLoading() {
    nextLoading = true;
    notifyListeners();
  }

  setSyncing() {
    isSyncing = true;
    notifyListeners();
  }

  List<storyarray.Result> items = List.empty(growable: true);
  DatabaseHelper _databaseHelper = DatabaseHelper();

  getStoriesFromRemote(String url, String program) async {
    var apiresponsedata = await _storyservice.getStory(url + "?limit=5");
    if (apiresponsedata.httpCode == 200) {
      items.addAll(apiresponsedata.data.results);
      await _databaseHelper.insertStory(items, program);
      items.forEach((element) {
        StorageUtil.writeStory(element.content, "${program}_${element.id}");
      });
      LoadDataHandling.storeStoryLastUpdate();
      isLoading = false;
      isSyncing = false;
      notifyListeners();
      sp.setInt("${program}_${SPUtil.STORY_COUNT}", apiresponsedata.data.count);

      if (apiresponsedata.data.count > 5) {
        itemCount = 5;
        notifyListeners();
      } else {
        itemCount = apiresponsedata.data.count;
      }

      if (apiresponsedata.data.next != null) {
        sp.setValue(
            "${program}_${SPUtil.STORY_NEXT}", apiresponsedata.data.next);
      }
    } else {
      isLoading = false;
      isSyncing = false;
      notifyListeners();
    }
  }

  checkForNextStories(String program) async {
    _databaseHelper.getStoryCount(program).then((value) => {
          if (itemCount < value)
            {
              itemCount = itemCount + 5,
              if (itemCount >= value)
                {
                  itemCount = value,
                  notifyListeners(),
                },
              notifyListeners()
            }
          else
            {getNextStoriesFromRemote(program)}
        });
  }

  getNextStoriesFromRemote(String program) async {
    if (sp.getValue("${program}_${SPUtil.STORY_NEXT}") != "null") {
      setNextLoading();
      items.clear();
      var apiresponsedata = await _storyservice
          .getStory(sp.getValue("${program}_${SPUtil.STORY_NEXT}"));
      if (apiresponsedata.httpCode == 200) {
        items.addAll(apiresponsedata.data.results);
        await _databaseHelper.insertStory(items, program);
        items.forEach((element) {
          StorageUtil.writeStory(element.content, "${program}_${element.id}");
        });

        itemCount = itemCount + 5;
        if (itemCount >= apiresponsedata.data.count) {
          itemCount = apiresponsedata.data.count - 1;
        }
        nextLoading = false;
        notifyListeners();
        if (apiresponsedata.data.next != null) {
          sp.setValue(
              "${program}_${SPUtil.STORY_NEXT}", apiresponsedata.data.next);
        } else {
          sp.setValue("${program}_${SPUtil.STORY_NEXT}", "null");
        }
      } else {
        nextLoading = false;
        notifyListeners();
      }
    }
  }

  getStoriesFromLocal(String program) {
    return _databaseHelper.getStories(program);
  }

  getRecentStory(String url, String program) {
    _databaseHelper.getRecentStory(program).then((value) => {
          if (value.length != 0)
            {
              if (sp.getInt("${program}_${SPUtil.STORY_COUNT}") > 5)
                {itemCount = 5, notifyListeners()},
              fetchFirstStoryFromRemote(url, program, value[0].id)
            }
          else
            {setLoading(), getStoriesFromRemote(url, program)}
        });
  }

  fetchFirstStoryFromRemote(String url, String program, int id) async {
    var apiResponseData = await _storyservice.getStory(url + "?limit=1");

    print(apiResponseData.httpCode);

    if (apiResponseData.httpCode == 200) {
      if (apiResponseData.data.results[0].id != id) {
        getStoriesFromRemote(url, program);
      } else {
        ClickSound.soundShare();
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
