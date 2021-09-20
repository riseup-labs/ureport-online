import 'package:flutter/material.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/response-opinion-localdb.dart';
import 'model/response_opinions.dart' as opinionsarray;
import 'opinion_repository.dart';
import 'model/response_opinions.dart' as questionArray;

class OpinionController extends ChangeNotifier{

  DatabaseHelper _databaseHelper = DatabaseHelper();
  var sp = locator<SPUtil>();

  int opinionID = 0;

  var isExpanded = false;
  void setExpanded(bool state){
    isExpanded = state;
    // notifyListeners();
  }

  var _opinionrepository = locator<OpinionRepository>();
  List<opinionsarray.Result> items = List.empty(growable: true);

  getOpinionsFromRemote(String url,String program) async {
    var apiresponsedata = await _opinionrepository.getOpinions(url);
    if(apiresponsedata.httpCode==200){
      items.addAll(apiresponsedata.data.results);
      if(apiresponsedata.data.next != null ){
        sp.setValue(SPUtil.OPINION_LATEST_POLL_DATE,apiresponsedata.data.results[0].pollDate.toString());
        getOpinionsFromRemote(apiresponsedata.data.next,program);
      }else{
        await _databaseHelper.insertOpinion(items,program);
        notifyListeners();
      }
    }
  }

  getOpinionsFromLocal(String program, int id) {
    return _databaseHelper.getOpinions(program, id);
  }

  getCategories(String program){
    return _databaseHelper.getOpinionCategories(program);
  }

}