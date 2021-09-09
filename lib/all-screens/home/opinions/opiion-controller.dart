import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/Response_opinions.dart';
import 'model/Response_opinions.dart' as quistoin;
import 'model/parse-sugetiondata.dart';
import 'opinion-repository.dart';

class OpinionController extends ChangeNotifier {
  var _opinionrepository = locator<OpinionRepository>();
  var spservice = locator<SPUtil>();
  List<String> category_names = [];
  String _resultCategorytype = "all";
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String get resultCategorytype => _resultCategorytype;
  set resultCategorytype(String value) {
    _resultCategorytype = value;
    notifyListeners();
  }

  bool _islodading = true;

  bool get islodading => _islodading;

  set islodading(bool value) {
    _islodading = value;
    notifyListeners();
  }

  Map<String, dynamic> newMap = {};

  bool _alllist = true;
  bool _agelist = false;
  bool _genderlist = false;
  bool _locationlist=false;




  bool _galllist=false;
  bool _gagelist=false;
  bool _ggenderlist=false;
  bool _glocationlist=false;


  bool _agalllist=false;
  bool _agagelist=false;
  bool _aggenderlist=false;
  bool _aglocationlist=false;


  bool get agalllist => _agalllist;

  set agalllist(bool value) {
    _agalllist = value;
    notifyListeners();
  }

  bool get galllist => _galllist;

  set galllist(bool value) {
    _galllist = value;
    notifyListeners();
  }

  bool get locationlist => _locationlist;

  set locationlist(bool value) {
    _locationlist = value;
    notifyListeners();
  }

  bool get alllist => _alllist;

  set alllist(bool value) {
    _alllist = value;
    notifyListeners();
  }

   int _indexlocal=0;


  int get indexlocal => _indexlocal;

  set indexlocal(int value) {
    _indexlocal = value;
    notifyListeners();
  }

  double fraction_value_yes = 0.0;
  TextEditingController _typeAheadController = TextEditingController();

  TextEditingController get typeAheadController => _typeAheadController;

  set typeAheadController(TextEditingController value) {
    _typeAheadController = value;
    notifyListeners();
  }

  List<quistoin.Question> quistionlist = [];
  List<quistoin.Question> reversequestionlist = [];
  List<quistoin.Result?> opinionList = [];
  List<String> category = [];
  List<String> title = [];
  ResponseOpinions? responseData;
  List<Sugetiondata> suggetiondataoptimized=[];
  String categorydefault="";
  String defaultTitle="";
  var sdata =<String, dynamic>{};


  initializeDatabase(){
    _databaseHelper.initializeDatabase().then((value) {

      print("the database story table created$value");
    });
  }


  getOpinionFromServer(String url,String program)async{

    var apiresponse = await _opinionrepository.getOpinions(url);
    if(apiresponse.httpCode==200){

      if(apiresponse.data.results.length>0){
        opinionList.addAll(apiresponse.data.results);
      }

      if(apiresponse.data.next!=null){
        getOpinionFromServer(apiresponse.data.next,program);

      }else{
        print("the data fetche from server size is ${opinionList.length}");
        await _databaseHelper.insertOpinion(opinionList, program).then((value) async{
          print("the programkey is........$program");
          category=[];
          quistionlist=[];
          defaultTitle="";
          categorydefault="";
          suggetiondataoptimized=[];
          await getofflinedata(program).then((value) => print(""));
          notifyListeners();

        });

      }

    }
    notifyListeners();
  }

  forceEmptydata(){
    var vv =quistoin.Results(categories: [],label: "",openEnded: false,resultsSet: 0,unset: 0);
   var v= quistoin.Question(title: "",id: 0,results: vv,resultsByAge: [],resultsByGender: [],resultsByLocation: [],rulesetUuid: "");
    quistionlist= List.empty();
    quistionlist.clear();
    notifyListeners();
  }

Future<bool> getofflinedata(String program)async{
  category=[];
  quistionlist=[];
  defaultTitle="";
  categorydefault="";
  suggetiondataoptimized=[];
  notifyListeners();
  print("the programke inside getofilnedata .......$program");
    await  getCategory(program).then((valued)async {
     if(category.isNotEmpty){
       await getTitle(valued[0]).then((value) {
         categorydefault=category[0];
         defaultTitle=title[title.length-1];
         print("the updated title is -----${category[0]}");
         getOfflineQuestions(title[title.length-1]);
       });

     }

    });
    notifyListeners();

    return true;

}
  getCategory(String program)async{
   var apiresponse= await _databaseHelper.getOpinionCategory(program);
   category.addAll(apiresponse);
   //getTitle(category[3]);
   for(int i=0;i<category.length;i++){
      await getTitle(category[i]).then((value){

        sdata["${category[i]}"]= value;
      });
   }
   suggetiondataoptimized =sdata.entries.map((e) => Sugetiondata(category: e.key, title: e.value)).toList();
   return category;
   notifyListeners();
  }


  Future<List<String>> getTitle(String category)async{
    var apiresponse= await _databaseHelper.getOpinionTitle(category);
    title=apiresponse;
   // getOfflineQuestions(title[0]);
    return title;
  }


  getOfflineQuestions(String programTitle)async{
    List<String> questionsJson= await _databaseHelper.getOpinionQuestion(programTitle);


    for(int i =questionsJson.length;i>0;i--){
      var apiresponse = await _opinionrepository.getOpinionsoffline(questionsJson[i-1]);
      quistionlist.addAll(apiresponse.data.toList());

    }

    print("the updated question is ${quistionlist[0].title}");


    notifyListeners();
  }


  String getmalepercentage(){

    if( quistionlist[0].resultsByGender[0].resultsSet!="NaN" && quistionlist[0].resultsByGender[0].unset!="NaN"
        && int.parse(quistionlist[0].resultsByGender[0].resultsSet.toString())!="NaN"
          && int.parse(quistionlist[0].resultsByGender[0].unset.toString())!="NaN"
    ){
      double fraction = quistionlist[0].resultsByGender[0].resultsSet/(quistionlist[0].resultsByGender[0].resultsSet + quistionlist[0].resultsByGender[0].unset);
      double parcentage= fraction*100;
      return parcentage.toStringAsFixed(2);
    }else return "0";

  }
  String getfemalepercentage(){

    if( int.parse(quistionlist[0].resultsByGender[1].resultsSet.toString()) is int &&int.parse(quistionlist[0].resultsByGender[1].resultsSet.toString()) is int
        && int.parse(quistionlist[0].resultsByGender[0].resultsSet.toString())!="NaN"
        && int.parse(quistionlist[0].resultsByGender[0].unset.toString())!="NaN"
    ){
      double fraction = quistionlist[0].resultsByGender[1].resultsSet/(quistionlist[0].resultsByGender[1].resultsSet+quistionlist[0].resultsByGender[1].unset);
      double parcentage= fraction*100;
      if(parcentage.toStringAsFixed(2)=="NaN"){
        return "0";
      }else return parcentage.toStringAsFixed(2);
    }else{
      return "0";
    }

  }




  List<Sugetiondata> getSuggestions(String query) =>
      suggetiondataoptimized.where((element) {
        final userlower = element.category.toLowerCase();
        final querydata = query.toLowerCase();
        return userlower.contains(querydata);
      }).toList();

  double getFractionOfYes(index) {
    if(quistionlist[index].results.categories.length>0){
      double fraction = (quistionlist[index].results.categories[0].count) /
          (quistionlist[index].results.resultsSet) *
          100;
      return fraction;
    }else return 0.0;
  }

  double getFractionOfNo(index) {
    if(quistionlist[index].results.categories.length>0){
      double fraction = (quistionlist[index].results.categories[1].count) /
          (quistionlist[index].results.resultsSet) *
          100;
      return fraction;
    }else{
      return 0.0;
    }
  }
  double getFractionProgressOfYes(index) {
   if(quistionlist[index].results.categories.length>0){
     double fraction = (quistionlist[index].results.categories[0].count) /
         (quistionlist[index].results.resultsSet);
     return fraction;
   }else return 0.0;
  }

  double getFractionProgressOfNo(index) {
   if(quistionlist[index].results.categories.length>0){
     double fraction = (quistionlist[index].results.categories[1].count) /
         (quistionlist[index].results.resultsSet);
     return fraction;
   }else{
     return 0.0;
   }
  }

  selectionHandling(String state) {
    if (state == "all") {
      resultCategorytype = "all";
    } else if (state == "age") {
      resultCategorytype = "age";
    } else if (state == "gender") {
      resultCategorytype = "gender";
    } else if (state == "location") {}

    notifyListeners();
  }

  double getFractionOfYesForGender(index, j, k) {
    if(quistionlist[index].resultsByGender[j].categories.length>0 && quistionlist[index].resultsByGender.length>0){
      double fraction =
          (quistionlist[index].resultsByGender[j].categories[k].count) /
              ((quistionlist[index].resultsByGender[j].resultsSet)) *
              100;
      return fraction;
    }else return 0.0;
  }

  double getFractionProgressForGender(index, j, k) {
    if(quistionlist[index].resultsByGender[j].categories.length>0 && quistionlist[index].resultsByGender.length>0){
      double fraction =
          (quistionlist[index].resultsByGender[j].categories[k].count) /
              ((quistionlist[index].resultsByGender[j].resultsSet));
      return fraction;
    }else return 0.0;
  }

  double getFractionProgressForage(index, j, k) {
    if ((quistionlist[index].resultsByAge[j].resultsSet) != 0) {
      double fraction =
          (quistionlist[index].resultsByAge[j].categories[k].count) /
              ((quistionlist[index].resultsByAge[j].resultsSet));
      return fraction;
    } else
      return 0.0;
  }

  double getFractionOforAge(index, j, k) {
    if ((quistionlist[index].resultsByAge[j].resultsSet) != 0) {
      double fraction =
          (quistionlist[index].resultsByAge[j].categories[k].count) /
              ((quistionlist[index].resultsByAge[j].resultsSet)) *
              100;
      return fraction;
    } else
      return 0.00;
  }



  double getFractionProgressForLocation(index, j, k) {
    if ((quistionlist[index].resultsByLocation[j].resultsByLocationSet) != 0) {
      double fraction =
          (quistionlist[index].resultsByLocation[j].categories[k].count) /
              ((quistionlist[index].resultsByLocation[j].resultsByLocationSet));
      return fraction;
    } else
      return 0.0;
  }

  double getFractionOforLocation(index, j, k) {
    if ((quistionlist[index].resultsByLocation[j].resultsByLocationSet) != 0) {
      double fraction =
          (quistionlist[index].resultsByLocation[j].categories[k].count) /
              ((quistionlist[index].resultsByLocation[j].resultsByLocationSet)) *
              100;
      return fraction;
    } else
      return 0.00;
  }



  bool get agelist => _agelist;

  set agelist(bool value) {
    _agelist = value;
    notifyListeners();
  }

  bool get genderlist => _genderlist;

  set genderlist(bool value) {
    _genderlist = value;
    notifyListeners();
  }

  bool get gagelist => _gagelist;

  set gagelist(bool value) {
    _gagelist = value;
    notifyListeners();
  }

  bool get ggenderlist => _ggenderlist;

  set ggenderlist(bool value) {
    _ggenderlist = value;
    notifyListeners();
  }

  bool get glocationlist => _glocationlist;

  set glocationlist(bool value) {
    _glocationlist = value;
    notifyListeners();
  }

  bool get agagelist => _agagelist;

  set agagelist(bool value) {
    _agagelist = value;
    notifyListeners();
  }

  bool get aggenderlist => _aggenderlist;

  set aggenderlist(bool value) {
    _aggenderlist = value;
    notifyListeners();
  }

  bool get aglocationlist => _aglocationlist;

  set aglocationlist(bool value) {
    _aglocationlist = value;
    notifyListeners();
  }
}
