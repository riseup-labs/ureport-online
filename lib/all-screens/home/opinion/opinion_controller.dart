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
  List<questionArray.Question> questionList = [];
  var sp = locator<SPUtil>();

  String opinionTitle = "";
  String opinionTitleEarlier = "";
  ResultOpinionLocal? opinions;
  void setOpinionTitle(String title){
    opinionTitle = title;
    notifyListeners();
  }


  var isExpanded = false;
  void setExpanded(bool state){
    isExpanded = state;
    notifyListeners();
  }

  var _opinionrepository = locator<OpinionRepository>();
  List<opinionsarray.Result> items = List.empty(growable: true);

  getOpinionsFromRemote(String url,String program) async {
    var apiresponsedata = await _opinionrepository.getOpinions(url);
    if(apiresponsedata.httpCode==200){
      items.addAll(apiresponsedata.data.results);

      // DateTime latestDate =  apiresponsedata.data.results[0].pollDate;
      // DateTime pastDate = DateTime.parse(sp.getValue(SPUtil.OPINION_LATEST_POLL_DATE));
      // var data = pastDate.isBefore(latestDate);

      if(apiresponsedata.data.next != null ){
        sp.setValue(SPUtil.OPINION_LATEST_POLL_DATE,apiresponsedata.data.results[0].pollDate.toString());
        getOpinionsFromRemote(apiresponsedata.data.next,program);
      }else{
        await _databaseHelper.insertOpinion(items,program);
        notifyListeners();
      }
    }
  }

  getOpinionsFromLocal(String program) {
    return _databaseHelper.getOpinions(program);
  }

  getQuestionsFromLocal(String? programTitle) async{

    questionList.clear();
    List<String?> questionsJson = await _databaseHelper.getOpinionQuestion(programTitle!);
    for(int i = questionsJson.length; i>0; i--){
      var apiresponse = await _opinionrepository.getOpinionQuestions(questionsJson[i-1]);
      questionList.addAll(apiresponse.data.toList());
    }
    notifyListeners();
  }

  getCategories(String program){
    return _databaseHelper.getOpinionCategories(program);
  }


}